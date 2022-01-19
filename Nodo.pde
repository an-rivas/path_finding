/*
Este archivo contiene la clase nodo que es la estructura principal para crear el árbol de búsqueda.
*/

class Nodo {
  Nodo padre;
  int[] posicion;
  int g=0, h=0;
  float f=0;
 
  Nodo(Nodo _padre, int[] _posicion) {
    padre = _padre;
    posicion = _posicion;
  }

  int[] pos() {
    return posicion;
  }
}
