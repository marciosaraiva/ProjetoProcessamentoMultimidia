class Botao {
  int cx;
  int cy; 
  int largura;
  int altura;
  color cor;
  String texto;
  PFont letra;
  boolean pintar;
  
  Botao(String t, String f, int x, int y, int l, int h, color c) {
    this.texto = t;
    this.letra = createFont(f,20);
    this.cx = x;
    this.cy = y;
    this.largura = l;
    this.altura = h;
    this.cor = c;
  }
  
  void desenha() {
    noStroke();
    rectMode(CENTER);
    if(pintar==true) {
      fill(cor);
    }else{
      fill(color(177,156,217));
    }
    rect(cx, cy, largura, altura);
    textFont(letra);
    textAlign(CENTER,CENTER);
    fill(0);
    text(texto,cx,cy);
  }
  
  void pinta() {
    if(mouseX > cx-(largura/2) && mouseX < cx+(largura/2) && mouseY > cy-(altura/2) && mouseY < cy+(altura/2)) {
      pintar=true;
    }else{
      pintar=false;
    }
  }

  boolean hit(float xx, float yy) {
    if(xx > cx-(largura/2) && xx < cx+(largura/2) && yy > cy-(altura/2) && yy < cy+(altura/2)) {
      return true;
    }else{
      return false;
    }
  }
}

class BotaoMenu extends Botao {
  
  BotaoMenu(String t, String f, int x, int y, int l, int h, color c) {
    super(t, f, x, y, l, h, c);
  }
  
  void desenha() {
    super.desenha();
  }
  
  void pinta() {
    super.pinta();
  }
}

class BotaoSair extends Botao {
  
  BotaoSair(String t, String f, int x, int y, int l, int h, color c) {
    super(t, f, x, y, l, h, c);
  }
  
  void desenha() {
    super.desenha();
  }
  
  void pinta() {
    super.pinta();
  }
}
  
  
  
