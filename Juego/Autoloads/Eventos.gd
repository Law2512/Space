#Eventos.gd
extends Node

signal baseDestruida(base, posiciones)
signal nave_destruida(nave, posicion, explosiones)
signal naveSectorPeligro(centroCamara, tipoPeligro, numeroPeligros)
signal disparo(proyectil)
signal spawnMeteorito(posicion, direccion, tamanio)
signal meteoritoDestruido(posicion)
signal spawnOrbital(orbital)
signal nivelIniciado()
signal nivelTerminado()

##HUD
signal detectorZonaRecarga(entrando)
signal cambioNumeroMeteoritos(numero)
signal actualizarTiempo(tiempoRestante)
signal cambioEnergiaLaser(energiaMax, energiaActual)
signal ocultarEnergiaLaser()
signal cambioEnergiaEscudo(energiaMax, energiaActual)
signal ocultarEnergiaEscudo()
signal minimapaObjetoCreado()
signal minimapaObjetoDestruido(objeto)
