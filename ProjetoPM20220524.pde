import processing.sound.*;
import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Movie video1, video2, video3;
Capture cam;
OpenCV opencv;

AudioIn som;
Amplitude amp;
float minAmp = 0.05;
FFT fft;
int bandas = 4;

ArrayList<EcraVazio> ecras = new ArrayList();
int i = 0;

//Variáveis do efeito letras

int n; //nº de linhas
int m; //nº de colunas
float w, h; //largura e altura
int k = 0;
String frase;

PImage frameAnterior;
PImage diferenca;
PImage binary;
float threshold = 50;

void setup() {
  size(640, 352);
  
  video1 = new Movie(this, "coimbra1.mp4");
  video2 = new Movie(this, "coimbra2.mp4");
  video3 = new Movie(this, "coimbra3.mp4");
  opencv = new OpenCV(this, 640, 352);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  som = new AudioIn(this, 0);
  som.start();
  amp = new Amplitude(this);
  amp.input(som);
  fft = new FFT(this, bandas);
  fft.input(som);
  
  String [] cameras = Capture.list();
  cam = new Capture(this, 640, 352, cameras[0], 30);
  cam.start();
  
  PImage img = loadImage("coimbra2.jpg");
  ecras.add(new EcraImagem("Descobre Coimbra", color(255,229,124), img));
  ecras.add(new EcraBotoes("Níveis", color(177,156,217), 3));
  ecras.add(new EcraEfQuadrados("Quadrados", color(255)));
  ecras.add(new EcraEfLetras("Letras", color(255)));
  ecras.add(new EcraEfLanterna("Lanterna", color(0)));
  
  setup2();
}

void draw() {
  ecras.get(i).desenha();
  if(i == 2) {
    if(video1.available() && cam.available()) {
      video1.read();
      cam.read();
    }
  }
  if (i == 3){
    EfLetras();
  }
  if (i == 4) {
    if(video3.available() && cam.available()) {
      video3.read();
      cam.read();
    }
  }
}

void mousePressed() {
  if (i == 0) {
    i=1;
  }
  else{    
    if(i==1 && ecras.get(1).getBotao(0).hit(mouseX, mouseY)) {
      i = 2;
      video1.loop();
      ecras.get(i).primeira_aparicao = true;
    }
    
    if(i==1 && ecras.get(1).getBotao(1).hit(mouseX,mouseY)) {
      i = 3;
      ecras.get(i).primeira_aparicao = true;
    }
    
    if(i==1 && ecras.get(1).getBotao(2).hit(mouseX,mouseY)) {
      i = 4;
      video3.loop();
      ecras.get(i).primeira_aparicao = true;
    }
    
    if(ecras.get(i).getBotaoMenu().hit(mouseX,mouseY)) {
      if (i > 1){
        i = 1;
        background(color(177,156,217));
        ecras.get(i).primeira_aparicao = true;
      }
    }
    if(ecras.get(1).getBotaoSair().hit(mouseX,mouseY)) {
      exit();
    }
  }
}
  
//Baseado no exercício 4.1.6- Texto
void setup2() {
  
  String[] lines = loadStrings("coimbra.txt");
  frase = lines[0];
  
  video2.loop();

  frameAnterior = new PImage(640, 352);
  diferenca = new PImage(640, 352);
  binary = new PImage(640,352);
  
  textAlign(LEFT,TOP);
  frase = frase.replaceAll(" ", "");
  frase = frase.toUpperCase(); 

  video2.loadPixels();
}

void EfLetras(){
  //A transparência depende da frequência do som, quanto mais agudo é o som, maior é a sua frequência e consequentemente mais transparente vai ser a cor da letra
  float[] espetro = fft.analyze();
  int[] transparencia = new int[1];
  for(int i=0; i<transparencia.length; i++) {
    transparencia[i]=int(map(espetro[i],minAmp,0.5,50,250));
  }
  //O nº de linhas e de colunas vai depender do volume do som captado, quanto mais alto for o som, mais linhas e colunas terá, quanto mais baixo for, terá um menor número de linhas e do colunas
  n=int(map(amp.analyze(),minAmp,0.5,100,400));
  m=int(map(amp.analyze(),minAmp,0.5,50,100));
  w = width/float(n);
  h = height/float(m);
  PFont f = createFont("Gill Sans MT Negrito", h); //O tamanho da fonte, será igual à altura obtida
  textFont(f);
  
  if(cam.available()) {
    cam.read();
    cam.loadPixels();
    frameAnterior.loadPixels();
    diferenca.loadPixels();
    binary.loadPixels();
  }
  
  //Baseado no exercício 5.2.5- Captura
  for(int i = 0; i<cam.pixels.length; i++) {
      float fR = red(cam.pixels[i]);
      float fG = green(cam.pixels[i]);
      float fB = blue(cam.pixels[i]);
      
      float aR = red(frameAnterior.pixels[i]);
      float aG = green(frameAnterior.pixels[i]);
      float aB = blue(frameAnterior.pixels[i]);
      
      diferenca.pixels[i] = color(fR-aR, fG-aG, fB-aB);
    }
    frameAnterior = cam.copy();
    
    int pixBranco=0;
    for(int i=0; i<diferenca.pixels.length; i++) {
      float b=brightness(diferenca.pixels[i]);
      if(b>threshold) {
        binary.pixels[i] = color(255);
        pixBranco++;
      }else{
        binary.pixels[i] = color(0);
      }
    }
    binary.updatePixels();
    
    for(int x = 0; x<video2.width; x++) {
      for(int y = 0; y<video2.height; y++) {
        int loc = x+y*video2.width;
        float r = red(video2.pixels[loc]);
        float g = green(video2.pixels[loc]);
        float b = blue(video2.pixels[loc]);
        float ajustar = map(pixBranco,1000,5000,1,2.5);
        r = constrain(r*ajustar,0,255);
        g = constrain(g*ajustar,0,255);
        b = constrain(b*ajustar,0,255);
        video2.pixels[loc] = color(r,g,b);
      }
    }
    
  //Tal como no efeito quadrados, só desenha caso a amplitude do som detetado for superior à amplitude mínima
  if(amp.analyze()>minAmp) {
    if(video2.available()) {
      video2.read();
    }
    
    //O número de letras a serem desenhadas depende da amplitude do som, quanto maior a amplitude, mais letras serão desenhadas, quanto menor a amplitude, menos letras serão desenhadas
    for(int nr=0; nr<map(amp.analyze(),minAmp,0.5,10,20); nr++) {
      for (int j = 0; j < m; j++) {
        for (int i = 0; i < n; i++) {
          //Baseado em https://processing.org/tutorials/pixels, com as adaptações ao contexto do nosso trabalho
          float r=red(video2.get(int(i*w),int(j*h)));
          float g=green(video2.get(int(i*w),int(j*h)));
          float b=blue(video2.get(int(i*w),int(j*h)));
          //O brilho vai depender do número de píxeis brancos, isto é, do movimento detetado pela câmara, no momento em que as letras são desenhadas
          //Quanto mais movimento houver, mais píxeis brancos estão a ser encontrados e mais brilhantes serão as cores
          //O contrário também se verifica, quanto menos movimento houver, menos píxeis brancos existem e as cores serão menos brilhantes, logo mais escuras
          //Usamos a função constrain de modo a que o valor obtido nunca seja superior ao limite máximo (255) ou inferior ao limite inferior (0), de modo a não alterar as cores da imagem original
          float ajustar=(map(pixBranco,1000,5000,1,1.5));
          r=constrain(r*ajustar,0,255);
          g=constrain(g*ajustar,0,255);
          b=constrain(b*ajustar,0,255);
          color c=color(r,g,b);
          //Na cor da cada letra é considerada também a transparência, tal como explicado anteriormente
          fill(c,transparencia[0]);
          text(frase.charAt(k), i*w, j*h);
          k = (k+1) % frase.length();
        }
      }
    }
  }
}
