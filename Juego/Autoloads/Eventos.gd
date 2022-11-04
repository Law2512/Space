#Eventos.gd
extends Node

signal nave_destruida(posicion, explosiones)
signal naveSectorPeligro(centroCamara, tipoPeligro, numeroPeligros)
signal disparo(proyectil)
signal spawnMeteorito(posicion, direccion, tamanio)
signal meteoritoDestruido(posicion)
