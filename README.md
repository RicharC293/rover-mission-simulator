Mars Rover Mission
=================

# Your Task
You’re part of the team that explores Mars by sending remotely controlled vehicles to the surface
of the planet. Develop a software that translates the commands sent from earth to instructions
that are understood by the rover.

# Requirements
* You are given the initial starting point (x,y) of a rover and the direction (N,S,E,W)
it is facing.
* The rover receives a collection of commands. (E.g.) FFRRFFFRL
* The rover can move forward (f).
* The rover can move left/right (l,r).
* Suppose we are on a really weird planet that is square. 200x200 for example :)
* Implement obstacle detection before each move to a new square. If a given
sequence of commands encounters an obstacle, the rover moves up to the last
possible point, aborts the sequence and reports the obstacle.


## ES
### Solución propuesta
* Implementar un software de control del rover que reciba instrucciones medainte una pantalla tipo chat.
* El plano se encuentra definido por un tamaño de 200x200 y se colocan obstáculos en el plano al azar.
* El rover inicialmente va a solicitar que se le indique el punto en donde se encuentra en el plano, este dato se lo ingresa en la aplicación a través de sliders que limitan el valor a las dimensiones del plano.
* El rover necesita una dirección inicial, la cual se le indica en la aplicación a través de botones que permiten seleccionar entre Norte, Sur, Este u Oeste.
* El rover indica mediante un mensaje en la aplicación que se encuentra listo para recibir instrucciones.
* Para que sea más fácil de identificar los mensajes del rover y los del usuario se identifica al rover con un avatar de imagen y se define al usuario como Huston mediante un avatar con la letra H.
* El rover recibe instrucciones a través de un campo de texto en la aplicación, en donde se pueden ingresar las instrucciones de movimiento del rover.
* Se va a simular una latencia de 1 segundo para cada instrucción que recibe el rover, esto con el fin de simular el tiempo que tarda en recibir la instrucción y ejecutarla.
* Cada movimiento que hace el rover se va a indicar en la aplicación mediante un mensaje.
* Si el rover se encuentra con un obstáculo, se va a indicar en la aplicación mediante un mensaje y se va a indicar la posición en donde se encuentra el obstáculo y la posición en donde se detuvo el rover.
* Si el rover quiere desplazarse fuera del plano, se va a indicar en la aplicación mediante un mensaje que el rover no puede salir del plano y la posición en donde se detuvo el rover.
* El rover puede tener un desplazamiento infinito que va a depender del número de instrucciones que reciba, pero una vez enviado el comando Huston debe esperar a que el rover termine de ejecutar las instrucciones para enviar un nuevo comando.

### Tecnologías utilizadas
* Flutter
* Dart
* Provider

### Instrucciones para ejecutar el proyecto
1. Clonar el repositorio
2. Abrir el proyecto en un editor de código
3. Ejecutar el comando `flutter pub get` para instalar las dependencias
4. Ejecutar el comando `flutter run` para ejecutar el proyecto
5. Seleccionar un emulador o dispositivo físico para ejecutar la aplicación
6. Interactuar con la aplicación

### Interacción con la aplicación
Este proyecto es una simulación de la misión Rover en el planeta Marte. El rover se mueve en un plano cartesiano y recibe instrucciones para moverse en el plano. El plano tiene un tamaño de 5x5 y el rover no puede salir de este plano. 

El rover necesita un punto inicial en el plano y una dirección inicial. El punto inicial se le indica al rover a través de dos sliders que limitan el valor a las dimensiones del plano. 
La dirección inicial se le indica al rover a través de botones que permiten seleccionar entre Norte, Sur, Este u Oeste.

El rover recibe instrucciones para moverse en el plano y estas instrucciones son las siguientes:

- L: gira 90 grados a la izquierda
- R: gira 90 grados a la derecha
- F: avanza una posición en la dirección en la que está mirando

El rover recibe una serie de instrucciones por ejemplo: 
- FFRFF: el rover se mueve dos posiciones hacia adelante, gira a la derecha y se mueve dos posiciones hacia adelante.


### Ejemplo de interacción

# rover-mission-simulator
