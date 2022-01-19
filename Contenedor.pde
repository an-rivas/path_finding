/*
Este archivo contiene la clase Contenedor y las tres subclases que heredan de este (Boton, Ventana y Tablero).
*/

class Contenedor {
  //rectangulo
  float posX;
  float posY;
  float anch;
  float alt;
  boolean isSelected;

  // si el boton necesita resaltar
  boolean active = true;

  private color arriba, abajo;

  Contenedor(float b_posX, float b_posY, float b_anch, float b_alt, boolean b_select) {
    posX = b_posX;
    posY = b_posY;
    anch = b_anch;
    alt = b_alt;
    isSelected = b_select;
  }

  void dibujar() {
    // elegir colores de cauerdo si esta seleccionado o no
    if (isSelected) {
      arriba = resalteObscuro;
      abajo = resalteClaro;
    }else{
      arriba = resalteClaro;
      abajo = resalteObscuro;
    }
    
    // dibujar las sombras para crear el contenedor
    rectMode(CENTER);
    noStroke();
    // iluminacion
    fill(arriba);
    //////// arriba
    rect(posX, posY-(alt/2), anch, 2); // 1
    rect(posX, posY-(alt/2)+2, anch-3, 2); // 2
    //////// izquierda
    rect(posX-(anch/2), posY, 2, alt); // 1
    rect(posX-(anch/2)+2, posY, 2, alt-3); // 2
    // sombras
    fill(abajo);
    //////// abajo
    rect(posX, posY+alt/2-1, anch, 2); // 1
    rect(posX, posY+alt/2-3, anch-3, 2); // 2
    //////// derecha
    rect(posX+(anch/2)-1, posY, 2, alt); // 1
    rect(posX+(anch/2)-3, posY, 2, alt-3); // 1
    
    if (!active) {
      fill(colorBotonCancelado);
      noStroke();
      rect(posX, posY, anch, alt);
    }

  }

  boolean inButton() {
    if (mouseX >= posX-anch/2 && mouseX <= posX+anch/2) {
      if (mouseY >= posY-alt/2 && mouseY <= posY+alt/2) {
        return true;
      }
    }
    return false;
  }
}

class Boton extends Contenedor {
  //imagen
  PImage img;

  //texto
  String texto;
  
  Boton(float b_posX, float b_posY, float b_anch, float b_alt, boolean b_select, PImage b_img, String b_text) {
    super(b_posX, b_posY, b_anch, b_alt, b_select);
    img = b_img;
    texto = b_text;
  }

  void mostrar() {
    // dibujar contenedor
    super.dibujar();

    // colocar la imagen y el texto
    fill(colorTexto);
    textFont(arcade);
    text(texto, posX, posY+(alt*3/8));
    image(img, posX, posY-(alt/8), 25, 25);
  }
}

class Ventana extends Contenedor {
  //rectangulo
  float alturaY;
  float largo;

  //texto
  String texto;
  int mensaje; //false es "volver", true es "cerrar"

  Ventana(float b_posY, float b_alt, int b_mensaje) {
    super(width/2, b_posY+b_alt-30, 70, 30, false);
    alturaY = b_posY;
    largo = b_alt;
    mensaje  = b_mensaje;
  }

  void mostrar() {
    // dibujar la ventana
    // rectangulo
    rectMode(CORNER);
    stroke(resalteClaro);
    strokeWeight(3);
    fill(colorBG);
    rect(100, alturaY, 324, largo);
    noStroke();
    // linea azul
    fill(ColorContraste);
    rect(103, alturaY+2, 320, 18);

    // colocar el boton
    if (mensaje == 1) {
      super.dibujar();
      textAlign(CENTER);
      fill(colorTexto);
      text("Cerrar", posX, posY+5);
    } else if (mensaje == 0){
      super.dibujar();
      textAlign(CENTER);
      fill(colorTexto);
      text("Volver", posX, posY+5);
    }
  }
}

class Tablero extends Contenedor {
  //imagen
  int tipo;
  
  Tablero(float b_posX, float b_posY, float b_anch, float b_alt, boolean b_select, int b_img) {
    super(b_posX, b_posY, b_anch, b_alt, b_select);
    tipo = b_img;
  }

  void mostrar() {
    // dibujar contenedor
    super.dibujar();
    
    // imagen
    switch (tipo) {
    case 1:
      image(obstaculo, posX, posY);
      break;
    case 2:
      image(partida, posX, posY);
      break;
    case 3:
      image(objetivo, posX, posY);
      break;
    }
  }
}
