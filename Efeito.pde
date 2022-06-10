//Baseado no exercício 6.3- Hierarquia

class Efeito {
  String nome;
  int cMode;
  
  Efeito(String nome, int cMode) {
    this.nome = nome;
    this.cMode = cMode;
  }
  
  PImage aplica(PImage original) {
    return original;
  }
  
  //Não recebe nada, devolve 1 string Efeito concatenado com o nome
  String toString() {
    return "Efeito; " + this.nome;
  }
}

class EfQuadrados extends Efeito {
  Quadrado[] quadrados;
  
  EfQuadrados(String nome, int cMode) {
    super(nome, cMode);
    //O número de quadrados que vão desenhar a figura vai depender da amplitude do som, quanto mais alto for o som, maior será o número de quadrados, e quanto mais baixo for, menor é o número de quadrados
    quadrados = new Quadrado[int(map(amp.analyze(), minAmp, 0.5, 5000, 10000))];
    
    for(int i = 0; i < quadrados.length; i++) {
      quadrados[i] = new Quadrado();
    }
  }
  
  PImage aplica(PImage original) {
    original.loadPixels();
    
    //Baseado no exercício 5.2.8- Vídeo
    //Foi considerado o brilho e saturação máximas como 0
    float maxBrightness = 0;
    float maxSaturation = 0;
    
    //Todos os píxeis da câmara foram varridos, de modo a encontrar aqueles que apresentavam um brilho superior ao brilho máximo e uma saturação superior à saturação máxima
    for(int b = 0; b < cam.pixels.length; b++) {
      if (brightness(cam.pixels[b]) > maxBrightness) {
        maxBrightness = brightness(cam.pixels[b]);
      }
      if(saturation(cam.pixels[b]) > maxSaturation) {
        maxSaturation = saturation(cam.pixels[b]);
      }
    }
    
    //De seguida, considerou-se um brilho e uma saturação médios equivalentes a 75% do brilho e da saturação máxima da imagem
    float med_bR = maxBrightness*0.75;
    float med_sT = maxSaturation*0.75;
    
    //Novamente, foram varridos todos os píxeis da câmara, de modo a encontrar aqueles que apresentavam um brilho e saturação superiores a 75% do brilho e saturação máximos
    for(int j = 0; j < cam.pixels.length; j++) {
      float bR = brightness(cam.pixels[j]);
      float sT = saturation(cam.pixels[j]);
      
      //Assim, no caso de um píxel da câmara, apresentar um brilho superior a 75% da saturação máxima, o píxel do vídeo original passa a ser amarelo 
      if(bR > med_bR) {
        video1.pixels[j] = color(255, 140, 0);
      }
      
      //No caso de um píxel da câmara apresentar uma saturação superior a 75% da saturação máxima, o píxel do vídeo original passa a ser laranja
      if(sT > med_sT) {
        video1.pixels[j] = color(255, 229, 124);
      }
      
      //Para ter em conta o brilho e a saturação, simultaneamente, considerou-se que o brilho e a saturação devem apresentar um valor superior a 85% da saturação máxima e do brilho máximo
      med_bR = maxBrightness*0.85;
      med_sT = maxSaturation*0.85;
      //Assim, caso um píxel da câmara apresente um valor de brilho e saturação superior a 85% do brilho e saturação máximos, simultaneamente, o vídeo original passa a ser verde
      if(bR > med_bR && sT > med_sT) {
        video1.pixels[j] = color(141, 236, 120);
      }
    }
    
    //Só desenha caso a amplitude do som detetado for superior à amplitude mínima, neste caso considerámos 0.05, de modo a que o ruído não seja detetado (este valor de minAmp foi o mesmo para as 3 transformações)
    if(amp.analyze() > minAmp) {
      for(int i = 0; i < quadrados.length; i++) {
        quadrados[i].desenha();
        quadrados[i].move();
      }
    }
    
    original.updatePixels();
    return original;
  }
  
  
  String toString() {
    return "Efeito; " + this.nome;
  }  
}

class EfLetras extends Efeito {
  String[] lines;
  String txt;
  
  EfLetras(String nome, int cMode, String[] lines) {
    super(nome, cMode);
    this.lines = lines;
    this.txt = lines[0];
  }

  String toString() {
    return "Efeito; " + this.nome;
  }
}

//Baseado no exercício 2.11- Imagem
class EfLanterna extends Efeito {
  
  EfLanterna(String nome, int cMode) {
    super(nome, cMode);
  }
  
  PImage aplica(PImage original) {
    original.loadPixels();
    
    float[] espetro = fft.analyze();
    int[] cores = new int[4];
    for(int i = 0; i < cores.length; i++) {
    cores[i] = int(map(espetro[i], minAmp, 0.5, 0, 255));
  }
    //Deteção de uma cara- Baseado em https://www.youtube.com/watch?v=YX41KXbMf_U, com as adaptações ao contexto do nosso trabalho
    opencv.loadImage(cam);
    Rectangle [] faces = opencv.detect();
    
    for(int i = 0; i < faces.length; i++) {
      //Este retângulo apenas seria desenhado caso quiséssemos obter um retângulo à volta da face detetada, no entanto, neste caso, queremos que a lanterna acompanhe o movimento da cara
      //rect(faces[i].x+(faces[i].width)/2, faces[i].y+(faces[i].height)/2, faces[i].width, faces[i].height);
      
      for(int x = 0; x < video3.width; x++) {
        for(int y = 0; y < video3.height; y++) {
          int loc = x+y*video3.width;
          
          float r = red(video3.pixels[loc]);
          float g = green(video3.pixels[loc]);
          float b = blue(video3.pixels[loc]);
            
          float d = dist(x, y, faces[i].x+(faces[i].width)/2, faces[i].y+(faces[i].height)/2);
          float tamLant = map(amp.analyze(), minAmp, 0.5, 40, 80);
          float brilho = map(d, 0, tamLant, 255, 0);
          
          r = constrain(r + brilho + cores[1], 0, 255);
          b = constrain(b + brilho + cores[2], 0, 255);
          g = constrain(g + brilho + cores[3], 0, 255);
          
          video3.pixels[loc] = color(r, g, b);
        }
      }
      original.updatePixels();
      image(video3,0,0);
    }   
    return original;
  }
  
  String toString() {
    return "Efeito; " + this.nome;
  }
}
 
