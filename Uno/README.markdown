#Autores
###Juan Sebastian Velez
###Juan Esteban Mosquera
###James David Benitez

Reto-­‐03: 
Diseñar e implementar un servicio de compartición sencilla de archivos entre clientes utilizando la arquitectura P2P y un middleware/framework P2P (FileP2P) 
  
##Modo de empleo
En la carpeta _reto3_ hay 2 archivos ejecutables, server.rb y client.rb. Se debe de ejecutar el primer archivo server.rb, especificando el puerto que se desea utulizar `$ ruby server.rb 5555`.

Despues de tener en ejecucion el servidor podemos correr cuantas instancias de client.rb deseemos. Para esto se debe de especificar la ip del servidor y su puerto `$ ruby client localhost 5555`.

#####Envio de mensajes
Simplemente en la consola de client se copia el mensaje y este sera transmitido a todos los peers conectados en el momento

#####ls
ls lista los ficheros y directorios ejemplo `ls /home/user/Escritorio`

#####cp
cp realiza la copia de un archivo que se encuentre en otro peer ejemplo `ls /home/user/Escritorio/readme.txt`

#####cd
cd desplaza al directorio indicado

#####-help
-help muestra en pantalla una lista de acciones que el usuario puede realizar
