//Basado en
//Autor: Rey Salcedo Padilla : http://usandojava.blogspot.com/2012/01/implementacion-de-pila-y-cola.html

/*
Este archivo contiene la clase Pila y la clase Cola.
*/

public class Pila extends ArrayList<Nodo>{
 
 //se añade un elemento a la pila.(push)
 public void apilar(Nodo dato){
  if(dato != null){
   this.add(dato);
  }else{
   System.out.println("Introduzca un dato no nulo");
  }  
 }
 
 //se elimina el elemento frontal de la pila.(pop)
 public void desapilar(){
  if(size() > 0){
   this.remove(this.size()-1);
  }
 }
 
 //devuelve el elemento que esta en la cima de la pila. (top o peek)
 public Nodo cima(){
  Nodo datoAuxiliar = null;
  if(this.size() > 0){
   datoAuxiliar = this.get(this.size()-1);
  }
  return datoAuxiliar;  
 }
 
 //devuelve cierto si la pila está vacía o falso en caso contrario (empty).
 public boolean vacia(){
  return this.isEmpty();
 }
}

import java.util.ArrayList;
public class Cola extends ArrayList<Nodo>{
 
 //se añade un elemento a la cola. Se añade al final de esta.
 public void encolar(Nodo dato){
  if(dato != null){
   this.add(dato);
  }else{
   System.out.println("Introduzca un dato no nulo");
  }  
 }

 //se elimina el elemento frontal de la cola, es decir, el primer elemento que entró.
 public void desencolar(int value){
  if(this.size() > 0){
   this.remove(value);
  }
 }
 
 //se devuelve el elemento frontal de la cola, es decir, el primer elemento que entró.
 public Nodo frente(int value){
  Nodo datoAuxiliar = null;
  if(this.size() >= value-1){
   datoAuxiliar = this.get(value);
  }
  return datoAuxiliar;  
 }
 
 //devuelve cierto si la pila está vacía o falso en caso contrario (empty).
 public boolean vacia(){
  return this.isEmpty();
 }
}
