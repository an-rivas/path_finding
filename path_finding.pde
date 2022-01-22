// Path finding use A* algorithm to find a path between two points in a matrix.
// Copyright (C) <2022>  Angelica Nayeli Rivas Bedolla (angelica.nayeli@comunidad.unam.mx)
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

/////////////////////// INTERFACE
// fuente de letras
PFont arcade, joint;
//imagenes
PImage obstaculo, partida, objetivo, borrar, ejecutar, instrucciones, repetir, opciones;
// botones
Boton b_obstaculo, b_inicio, b_objetivo, b_borrar, b_ejecutar, b_opciones, b_instrucciones, b_reiniciar;
// ventanas emergentes
Ventana ventana_errores, warranty, engrane, libro;

// medidas del tablero
int filas = 20, bs = 25; //valor de largo y ancho de cada cuadro en Tablero
//objeto tablero
Tablero[][] tablero = new Tablero[20][20];

// tipo de objeto que se tiene seleccionado al momento
int objectType; // 0 ninguno, 1 arbol, 2 punto de partida, 3 punto objetivo, 4 borrador

// texto de la garantia
String garantia = "This program is distributed in the hope that it will be\nuseful, but WITHOUT ANY WARRANTY; without\neven the implied warranty of MERCHANTABILITY or\nFITNESS FOR A PARTICULAR PURPOSE. See the GNU\nGeneral Public License for more details.";
String condiciones = "This program is free software; you can redistribute it\nand/or modify it under the terms of the GNU\nGeneral Public License as published by the Free Software\nFoundation; either version 2 of the License, or (at\nyour option) any later version.";

// public color resalteClaro=#FEC9F1, resalteObscuro=#948D9B, colorTexto=0, colorBotonCancelado=color(0, 0, 0, 50), colorBG=#C9C9C9, ColorContraste=#220486;
public color resalteClaro=#F5F5F5, resalteObscuro=#818181, colorTexto=0, colorBotonCancelado=color(0, 0, 0, 50), colorBG=#C9C9C9, ColorContraste=#220486;

/////////////////////// A*
int i, indexActual;
static final int[][] vecinos = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}, {-1, -1}, {-1, 1}, {1, -1}, {1, 1}};

int[] startUbicacion = {-1, -1}; // ubicacion del punto de partida con valores invalidos
int[] finishUbicacion = {-1, -1}; // ubicacion del punto objetivo con valores invalidos

int[] inicio = {1, 0}, fin = {7, 3};
ArrayList<int[]> camino = new ArrayList();
Pila lista_cerrada = new Pila();
Cola lista_abierta = new Cola();
Nodo nodo_inicial, nodo_actual;

boolean flag = false; // bandera para saber cuando el nodo actual ya fue revisado

/////////////////////// Maquina de estados
static final int JUGANDO = 0;
static final int AESTRELLA = 1;
static final int OPCIONES = 2;
static final int RESULTADO = 3;
static final int REGLAS = 4;
static final int SINSOLUCION = 5;
static final int ERRORPUNTOS = 6;
static final int LICENSE = 7;
int estado = LICENSE, estadoAnterior = JUGANDO;

void setup() {
  size(524, 619);

  // crear fuente de letra y asignarla
  arcade = createFont("arcadeclassic/ARCADECLASSIC.TTF", 10);
  joint = createFont("butterzone/ButterzoneDEMO.otf", 10);
  textAlign(CENTER);

  //crear el tablero
  for (int i=0; i<filas; i++) {
    for (int j=0; j<filas; j++) {
      tablero[j][i] = new Tablero(i*bs+26, j*bs+116, bs, bs, false, 0);
    }
  }

  // cargar las imágenes
  imageMode(CENTER);
  obstaculo = loadImage("images/tree.png");
  partida = loadImage("images/person.png");
  objetivo = loadImage("images/final_flag.png");
  borrar = loadImage("images/eraser.png");
  ejecutar = loadImage("images/play.png");
  opciones = loadImage("images/mesh.png");
  instrucciones = loadImage("images/instructions.png");
  repetir = loadImage("images/again.png");

  // crear los botones
  b_obstaculo = new Boton(63, 50, 60, 52, false, obstaculo, "obstaculo");
  b_inicio = new Boton(143, 50, 60, 52, false, partida, "partida");
  b_objetivo = new Boton(223, 50, 60, 52, false, objetivo, "objetivo");
  b_borrar = new Boton(303, 50, 60, 52, false, borrar, "borrar");
  b_ejecutar = new Boton(383, 50, 60, 52, false, ejecutar, "ejecutar");
  b_opciones = new Boton(463, 50, 60, 52, false, opciones, "opciones");
  b_instrucciones = new Boton(width/2-70, height/2+10, 85, 52, false, instrucciones, "explicacion");
  b_reiniciar = new Boton(width/2+70, height/2+10, 85, 52, false, repetir, "reiniciar");

  // crear las ventanas emergentes
  ventana_errores = new Ventana(245, 140, 1);
  warranty = new Ventana(215, 210, -1);
  engrane = new Ventana(184, 250, 0);
  libro = new Ventana(115, 390, 0);
}

void draw() {
  frameRate(60);
  ////// DIBUJAR TABLERO
  background(colorBG);
  for (int i=0; i<20; i++) {
    for (int j=0; j<20; j++) {
      tablero[i][j].mostrar();
    }
  }
  ////// DIBUJAR DETALLES
  noFill();
  rectMode(CORNER);
  noStroke();

  // iluminacion
  fill(resalteClaro);
  rect(10, height-17, width-20, 3);// tablero: abajo
  rect(width-12, 100, 3, height-115); // tablero: derecha

  // sombras
  fill(resalteObscuro);
  rect(10, 100, width-20, 3); // tablero: arriba
  rect(10, 100, 3, height-116); // tablero: izquierda

  ////// DIBUJAR OPCIONES
  b_obstaculo.mostrar();
  b_inicio.mostrar();
  b_objetivo.mostrar();
  b_borrar.mostrar();
  b_ejecutar.mostrar();
  b_opciones.mostrar();

  switch (estado) {
  case JUGANDO:
    if (mousePressed) {
      for (int i=0; i<filas; i++) {
        for (int j=0; j<filas; j++) {
          // si se presiona el raton en la posicion i,j del tablero, hay algun tipo de objeto en uso y esta en modo juego
          if (tablero[i][j].inButton() && objectType != 0 && estado==JUGANDO) {
            // si el boton actual seleccionado es arbol
            // i,j, se define como posicion ocupada y se pinta del color del arbol
            if (objectType == 1 && tablero[i][j].tipo==0) {
              // tablero[i][j].isSelected = true;
              tablero[i][j].tipo = 1;
            }
            // si el boton actual seleccionado es borrador
            // i,j se define como posicion desocupada y se pinta del color por defecto del tablero
            if (objectType == 4) {
              tablero[i][j].tipo = 0;
              // para ambos casos de punto de partida y punto de llegada
              // la variable posicion tendrá valores invalidos y se activa el boton de seleccion del objeto
              if (i==startUbicacion[0] && j==startUbicacion[1]) {
                startUbicacion[0] = -1;
                startUbicacion[1] = -1;
                b_inicio.isSelected = false;
                b_inicio.active = true;
              }
              if (i==finishUbicacion[0] && j==finishUbicacion[1]) {
                finishUbicacion[0] = -1;
                finishUbicacion[1] = -1;
                b_objetivo.isSelected = false;
                b_objetivo.active = true;
              }
            }
          }
        }
      }
    }
    break;
  case OPCIONES:
    if (estadoAnterior==JUGANDO) {
      b_reiniciar.isSelected = false;
    } else {
      b_reiniciar.isSelected = true;
    }
    opciones();
    break;
  case AESTRELLA:
    if (startUbicacion[0]==-1 || startUbicacion[1]==-1 || finishUbicacion[0]==-1 || finishUbicacion[1]==-1) {
      estado = ERRORPUNTOS;
    } else {
      println("empieza a*");
      //limpiar las viariables lista_abierta, lista_cerrada asegurando que no haya un camino previo
      camino.clear();
      lista_abierta.clear();
      lista_cerrada.clear();

      // crear los nodos de inicio y final
      nodo_inicial = new Nodo( null, startUbicacion);
      // llamo A*
      AEstrella(tablero, nodo_inicial, finishUbicacion);
      println("termina a*");

      // creo la variable que iterara sobre el arreglo camino y que se dibujara un cuadro cada iteracion o se mostrará el error
      if (camino.size() == 0) {
        estadoAnterior = estado;
        estado = SINSOLUCION;
      } else {
        i = camino.size()-1;
        estadoAnterior = estado;
        estado = RESULTADO;
      }

      b_ejecutar.img = repetir;
      b_ejecutar.texto = "otra vez";

      b_obstaculo.isSelected = true;
      b_borrar.isSelected = true;
      b_inicio.isSelected = true;
      b_objetivo.isSelected = true;
    }
    b_ejecutar.isSelected = false;
    break;
  case RESULTADO:
    if (i>=0) {
      frameRate(6);
      dibujarCamino();
      i--;
    }
    break;
  case SINSOLUCION:
    error(0);
    break;
  case REGLAS:
    reglas();
    break;
  case ERRORPUNTOS:
    error(1);
    break;
  case LICENSE:
    if (frameCount<300) {
      fill(0);
      rect(width/2, height/2, width, height);

      fill(255);
      textFont(joint);
      text("Gnomovision version 69, Copyright (C) 2022 Angelica Nayeli Rivas Bedolla Gnomovision comes\nwith ABSOLUTELY NO WARRANTY; for details press 'w'.  This is free\nsoftware, and you are welcome to redistribute it under certain conditions;\npress 'c' for details.", width/2, 298);
    } else {
      estado = JUGANDO;
    }
    break;
  }

  //license
  if (keyPressed) {
    if (key == 'w') {
      licencia(1);
    }
    if (key == 'c') {
      licencia(2);
    }
  }
}


void mousePressed() {
  // si se presiona el boton para seleccionar el objeto y no se tiene ningun otro boton en uso
  // se cambia el estado de seleccionado a no seleccionado (o viceversa) y se define el tipo de objeto actual
  if (estado==JUGANDO) {
    if (b_obstaculo.inButton()) {
      b_obstaculo.isSelected = !b_obstaculo.isSelected;
      deseleccionarBoton();
      objectType = (b_obstaculo.isSelected == true)  ? 1 : 0;
    } else if (b_inicio.inButton() && b_inicio.active) {
      b_inicio.isSelected = !b_inicio.isSelected;
      deseleccionarBoton();
      objectType = (b_inicio.isSelected == true)  ? 2 : 0;
    } else if (b_objetivo.inButton() && b_objetivo.active) {
      b_objetivo.isSelected = !b_objetivo.isSelected;
      deseleccionarBoton();
      objectType = (b_objetivo.isSelected == true) ? 3 : 0;
    } else if (b_borrar.inButton()) {
      b_borrar.isSelected = !b_borrar.isSelected;
      deseleccionarBoton();
      objectType = (b_borrar.isSelected == true) ? 4 : 0;
    }
  }
  // si se presiona el boton de ejecutar estando en el estado de JJUGANDO o RESULTADO
  if ((estado==RESULTADO || estado==JUGANDO)&& b_ejecutar.inButton()) {
    if (b_ejecutar.texto=="ejecutar") {
      b_ejecutar.isSelected = !b_ejecutar.isSelected;
      estadoAnterior = estado;
      estado = AESTRELLA;
    } else {
      b_ejecutar.img = ejecutar;
      b_ejecutar.texto = "ejecutar";

      b_obstaculo.isSelected = false;
      b_borrar.isSelected = false;
      estadoAnterior = estado;
      estado = JUGANDO;

      //reiniciar el tablero donde el camino
      if (camino.size() > 0) {
        for (i=0; i<camino.size(); i++) {
          dibujarCamino();
        }
      }
    }
  }
  // Si se presiona el boton de opciones estando fuera del estado de opciones
  if (b_opciones.inButton() && estado!=OPCIONES) {
    b_opciones.isSelected = !b_opciones.isSelected;
    // abrir ventana de OPCIONES
    estadoAnterior = estado;
    estado = OPCIONES;
  }
  //si esta en el estado de opciones
  //verificar si se presionan alguno de los botones disponibles en este estado
  if (estado == OPCIONES) {
    if (engrane.inButton()) {
      b_opciones.isSelected = !b_opciones.isSelected;
      estado = estadoAnterior;
    }
    if (b_reiniciar.inButton()) {
      //reiniciar el tablero
      for (int i=0; i<filas; i++) {
        for (int j=0; j<filas; j++) {
          tablero[i][j].tipo = 0;
          tablero[i][j].isSelected = false;
          tablero[i][j].active = true;
        }
      }
      b_objetivo.isSelected = false;
      b_objetivo.active = true;
      finishUbicacion[0] = -1;
      finishUbicacion[1] = -1;
      b_inicio.isSelected = false;
      b_inicio.active = true;
      startUbicacion[0] = -1;
      startUbicacion[1] = -1;

      objectType=0;
      b_obstaculo.isSelected = false;
      b_borrar.isSelected = false;
    }
    if (b_instrucciones.inButton()) {
      estado = REGLAS;
    }
  }
  //si se presiona salir en la ventana de reglas
  if (estado == REGLAS) {
    if (libro.inButton()) {
      estado = OPCIONES;
    }
  }
  if (estado==ERRORPUNTOS || estado==SINSOLUCION) {
    if (ventana_errores.inButton()) {
      estado = JUGANDO;
      b_ejecutar.img = ejecutar;
      b_ejecutar.texto = "ejecutar";
      b_obstaculo.isSelected = false;
      b_borrar.isSelected = false;
    }
  }

  for (int i=0; i<filas; i++) {
    for (int j=0; j<filas; j++) {
      // si se presiona el raton en la posicion i,j del tablero, hay algun tipo de objeto en uso, el punto no está en uso y el estado es JUGANDO
      if (tablero[i][j].inButton() && objectType != 0 && tablero[i][j].tipo==0 && estado==JUGANDO) {
        // para ambos casos de punto de partida y punto de llegada
        // i,j se define como posicion ocupada y se pinta del color del punto correspondiente
        // la variable posicion tendrá los valores i,j y se desactiva el boton de seleccion del objeto
        if (objectType == 2 && startUbicacion[0]==-1 && startUbicacion[1]==-1) {
          lista_abierta.clear();
          tablero[i][j].tipo = 2;
          b_inicio.active = false;
          objectType = 0;

          startUbicacion[0] = i;
          startUbicacion[1] = j;
        }
        if (objectType == 3 && finishUbicacion[0]==-1 && finishUbicacion[1]==-1) {
          tablero[i][j].tipo = 3;
          b_objetivo.active = false;
          objectType = 0;

          finishUbicacion[0] = i;
          finishUbicacion[1] = j;
        }
      }
    }
  }
}

void licencia(int tipoTextoLicencia) {
  fill(0, 0, 0, 50);
  noStroke();
  rect(width/2, height/2, width, height);
  warranty.mostrar();

  textFont(joint);
  fill(colorTexto);
  if (tipoTextoLicencia==1) {
    text(garantia, width/2, height/2-15);
  } else {
    text(condiciones, width/2, height/2-15);
  }
}

void error(int tipoError) {
  // sombra detrás
  fill(0, 0, 0, 50);
  noStroke();
  rect(width/2, height/2, width, height);
  ventana_errores.mostrar();

  fill(colorTexto);
  textFont(arcade, 15);
  if (tipoError==1) {
    text("Favor  de  elegir  puntos  de\npartida  y  objetivo", width/2, height/2-15);
  } else {
    text("No  se  encontro  solucion  para  este  mapa", width/2, height/2);
  }
}

void opciones() {
  // sombra detrás
  fill(0, 0, 0, 50);
  noStroke();
  rect(width/2, height/2, width, height);
  engrane.mostrar();

  textFont(arcade, 15);
  fill(colorTexto);
  text("OPCIONES", width/2, 245);

  ////// DIBUJAR OPCIONES
  b_instrucciones.mostrar();
  b_reiniciar.mostrar();
}

void reglas() {
  fill(0, 0, 0, 50);
  noStroke();
  rect(width/2, height/2, width, height);
  libro.mostrar();

  textFont(joint);
  fill(colorTexto);
  text("PATHFINDING  es  un  area  de  la  IA  que  tiene\ncomo  objetivo  encontrar  el  camino  mas  corto\nde  un  punto  a  otro.", width/2, 175);
  text("Este  juego  usa  el  algoritmo  A*  que\nhace  una  busqueda  heuristica  en  el  grafo  de\nposibilidades  para  encontrar  un  posible  camino.", width/2, 225);
  text("Como jugar:", width/2, 285);
  text("1  El  objeto  obstaculo  para  poner\nobstaculos  en  el  camino", width/2, 310);
  text("2  El  objeto  partida  para  establecer\nun  punto  de  partida  (solo  uno)", width/2, 345);
  text("3  El  objeto  objetivo  para  establecer\nun  punto  de  llegada  (solo  uno)", width/2, 380);
  text("4  El  objeto  borrar  para  eliminar  obstaculos\ny  los  puntos  de  partida  y  llegada", width/2, 415);
}

void dibujarCamino() {
  tablero[camino.get(i)[0]][camino.get(i)[1]].isSelected = !tablero[camino.get(i)[0]][camino.get(i)[1]].isSelected;
  tablero[camino.get(i)[0]][camino.get(i)[1]].active = !tablero[camino.get(i)[0]][camino.get(i)[1]].active;
}

void deseleccionarBoton() {
  if (objectType!=0) {
    if (objectType==1) {
      b_obstaculo.isSelected = false;
    } else if (objectType==2) {
      b_inicio.isSelected = false;
    } else if (objectType==3) {
      b_objetivo.isSelected = false;
    } else if (objectType==4) {
      b_borrar.isSelected = false;
    }
  }
}

void AEstrella(Tablero[][] map, Nodo nodo_inicial, int[] fin) {
  // el nodo inicial añadirlo a los que se exploraran
  lista_abierta.encolar(nodo_inicial);

  //busqueda A*
  while (lista_abierta.size()>0) {
    // Obtener el mejor hasta el momento
    // sacar de la cola y meter a la pila al nodo actual
    nodo_actual = lista_abierta.frente(0);
    indexActual = 0;
    // iterar sobrer los nodos disponibles
    for (i=0; i<lista_abierta.size(); i++) {
      if (lista_abierta.get(i).f < nodo_actual.f) {
        indexActual = i;
        nodo_actual = lista_abierta.frente(indexActual);
      }
    }

    lista_abierta.desencolar(indexActual);
    lista_cerrada.apilar(nodo_actual);

    // si se llego a la posicion final, devolver el camino
    if (nodo_actual.posicion[0]==fin[0] && nodo_actual.posicion[1]==fin[1]) {
      while (nodo_actual != null) {
        camino.add(nodo_actual.posicion);
        nodo_actual = nodo_actual.padre;
      }
      return;
    }

    // generar hijos
    for (i=0; i<8; i++) {
      //calcular la nueva posicion
      int[] nuevo_hijo = {nodo_actual.posicion[0]+vecinos[i][0], nodo_actual.posicion[1]+vecinos[i][1]};
      //verificar que este en el mapa
      if ((nuevo_hijo[0]>=0 && nuevo_hijo[0]<filas) &(nuevo_hijo[1]>=0 && nuevo_hijo[1]<filas)) {
        // verificar que no sea obstaculo
        if (map[nuevo_hijo[0]][nuevo_hijo[1]].tipo != 1) {
          // si el hijo no esta en los ya explorados
          for (int j=0; j<lista_cerrada.size(); j++) {
            if (nuevo_hijo[0]==lista_cerrada.get(j).posicion[0] && nuevo_hijo[1]==lista_cerrada.get(j).posicion[1]) {
              flag = true;
            }
          }
          if (!flag) {
            // si el hijo no está en la lista abierta (por explorar)
            for (int j=0; j<lista_abierta.size(); j++) {
              if (nuevo_hijo[0]==lista_abierta.get(j).posicion[0] && nuevo_hijo[1]==lista_abierta.get(j).posicion[1]) {
                flag = true;
              }
            }
            if (!flag) {
              Nodo hijos = new Nodo(nodo_actual, nuevo_hijo);

              // generar f, g y h
              hijos.g = nodo_actual.g+1;
              hijos.h = int(pow( hijos.posicion[0]-fin[0], 2)+pow( hijos.posicion[1]-fin[1], 2));
              hijos.f = hijos.g + hijos.h;
              lista_abierta.encolar(hijos);
            }
          }
        }
        // volver al valor inicial
        flag = false;
      }
    }
  }

  return;
}


/*
Dar credito al de la font
 */
