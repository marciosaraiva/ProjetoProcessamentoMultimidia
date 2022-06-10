//Adaptado de https://www.youtube.com/watch?v=NbX3RnlAyGU, com as adaptações ao contexto do nosso trabalho

class Quadrado {
  float x;
  float y;
  float a;
  float v;
  float vx;
  float vy;
  
  Quadrado() {
    //Os quadrados desenhados partem do centro da janela com uma velocidade aleatória entre 1 e 3
    x = width/2;
    y = height/2;
    a = random(2*PI);
    v = random(1,3);
    vx = cos(a)*v;
    vy = sin(a)*v;
  }
  
  void desenha() {
    //A cor dos quadrados corresponde à cor do pixel da imagem
    noStroke();
    color c = video1.get(int(x),int(y));
    fill(c);
    //O tamanho do quadrado é proporcional à amplitude do som, quanto maior a amplitude maior é o tamanho do quadrado e quando menor for a amplitude menor é o tamanho do quadrado (variando entre 1 e 10)
    square(x, y, map(amp.analyze(), 0.001, 0.5, 1, 10));
  }
  
  void move() {
    //Os quadrados movem-se com uma velocidade em x e uma velocidade em y
    //Caso o valor de y seja menor que 0, os quadrados passam a ser desenhados no final da janela (y=height) (de baixo para cima)
    //Caso o valor de y seja superior à altura da janela, os quadrados são desenhados no topo da janela (y=0) (de cima para baixo)
    //O mesmo acontece com o valor do x
    x = x+vx;
    y = y+vy;
    
    if(x < 0) {
      x = width;
    }
    if(x>width) {
      x = 0;
    }
    if(y < 0) {
      y=height;
    }
    if(y > height) {
      y = 0;
    }
  }
}
