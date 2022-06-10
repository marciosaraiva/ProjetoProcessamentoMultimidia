class EcraVazio {
  int margemX = 75;
  int margemY = 75;
  PFont letra;
  String texto;
  color cor;
  int larguraMenu = 60;
  int larguraPadrao = 200;
  int larguraSair = 50;
  int altura = 40; 
  Botao[] bot;
  BotaoMenu botM;
  BotaoSair botS;
  boolean primeira_aparicao = true;

  EcraVazio(String t, color c) {
    this.texto = t;
    this.cor = c;
    botM = new BotaoMenu("Menu", "Gill Sans MT Negrito", 580, 300, larguraMenu, altura, color(255,229,124));
    botS = new BotaoSair ("Sair", "Gill Sans MT Negrito", 50, 300, larguraSair, altura, color(255,229,124));
    letra = createFont("Gill Sans MT Negrito", 35);
  }

  void desenha() {
    if(primeira_aparicao){
      background(cor);
      primeira_aparicao = false;
    }
    //A fonte é usada no desenha, usada quando definimos o título da janela
    textFont(letra);
    fill(0);
    textAlign(CENTER, TOP);
    text(texto, width/2, 35);
  }
  
  Botao getBotao(int i) {
    return bot[i];
  }
  
  BotaoMenu getBotaoMenu() {
    return botM;
  } 
  
  BotaoSair getBotaoSair() {
    return botS;
  }
}

class EcraImagem extends EcraVazio {
  PImage img;

  EcraImagem(String t, color c, PImage img) {
    super(t, c);
    this.img = img;
  }

  void desenha() {
    super.desenha();
    image(img, margemX, margemY, width-(margemX*2), height-(margemY*2));
  }
}

class EcraBotoes extends EcraVazio {
  int margemX = 100;
  int margemY = 100;
  int numero;
  int margem;
  
  EcraBotoes(String t, color c, int n) {
    super(t, c);
    this.numero = n;
    this.margem = 15;
    this.altura = (height - (margemY*2) - (numero-1)*margem) / numero;
    bot = new Botao[n];
    for(int i = 0; i < n; i++) {
      bot[i] = new Botao("Nível " + (i+1), "Gill Sans MT Negrito", width/2, margemY+altura/2 + i*(margem+altura), larguraPadrao, altura, color(255,229,124)); 
    }
  }
  
  void desenha() {
    super.desenha();
    for(int i = 0; i < numero; i++) {
      bot[i].pinta();
      bot[i].desenha();
    }
    botS.pinta();
    botS.desenha();
  }
}

class EcraEfQuadrados extends EcraVazio {
  int margemX = 0;
  int margemY = 0;
  int numero;
  int margem;
  EfQuadrados EfQ;
  
  EcraEfQuadrados(String t, color c) {
    super(t, c);
    EfQ = new EfQuadrados("Efeito Quadrados", 200);
  }
  
  void desenha() {
    super.desenha();
    EfQ.aplica(video1);
    botM.pinta();
    botM.desenha();
  }
}

class EcraEfLetras extends EcraVazio {
  int margemX = 0;
  int margemY = 0;
  int numero;
  int margem;
  EfLetras EfL;
  
  EcraEfLetras(String t, color c) {
    super(t, c);
    EfL = new EfLetras("Efeito Letras", 200, loadStrings("coimbra.txt"));
  }
  
  void desenha() {
    super.desenha();
    EfL.aplica(video2);
    botM.pinta();
    botM.desenha();
  }  
} 

class EcraEfLanterna extends EcraVazio {
  int margemX = 0;
  int margemY = 0;
  int numero;
  int margem;
  EfLanterna EfLant;
  
  EcraEfLanterna(String t, color c) {
    super(t, c);
    EfLant = new EfLanterna("Efeito Lanterna", 200);
  }
  
  void desenha() {
    super.desenha();
    EfLant.aplica(video1); 
    botM.pinta();
    botM.desenha();
  }
} 
