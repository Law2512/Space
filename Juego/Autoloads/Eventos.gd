#Eventos.gd
extends Node

signal baseDestruida(base, posiciones)
signal nave_destruida(nave, posicion, explosiones)
signal naveSectorPeligro(centroCamara, tipoPeligro, numeroPeligros)
signal disparo(proyectil)
signal spawnMeteorito(posicion, direccion, tamanio)
signal meteoritoDestruido(posicion)
signal spawnOrbital(orbital)
