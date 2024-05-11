# Procesamiento de imagen usando CUDA y openCV

Este repositorio contiene la base de código para ejecutar varios algoritmos paralelos basados en GPU para el procesamiento de imágenes. Algunos de los algoritmos implementados son el desenfoque de imágenes, el volteo de imágenes y más. Estos algoritmos paralelos se ejecutan en una GPU utilizando CUDA.

### Casos de prueba

Para ejecutar nuestros casos de prueba, ejecuta  
`chmod u+x ex_single.sh`  
`chmod u+x ex_batch.sh`

Para ejecutar nuestros casos de prueba en modo de imagen única, ejecuta  
`ex_single.sh`

Esto ejecutará todos nuestros filtros en la imagen "images/lena_rgb.png".  
Deberían generarse siete imágenes en un nuevo directorio llamado output.  
Cada imagen es la salida del filtro que lleva su nombre. Para comprobar  
la corrección de la salida, compara cada imagen con la correspondiente  
imagen en el directorio expected_output. También puedes comparar cada  
imagen de salida con la original "images/lena_rgb.png".

Para ejecutar nuestros casos de prueba en modo de lotes de imágenes, ejecuta  
`ex_batch.sh`

Primero, esto hará 100 copias de "images/lena_rgb.png" en images/batch/  
Esto nos ayudará a generar un gran número de imágenes. Segundo, el script  
las filtrará con el filtro de detección de bordes en modo de lotes. Se  
leerán todas las imágenes, se filtrarán y se escribirán de nuevo. Escribir estas imágenes  
llevará algo de tiempo. Compara cualquier imagen en el directorio output/batch/ con  
"expected_output/edge.png" para verificar si la salida es correcta.

Si prefieres no ejecutar nuestros scripts, puedes ejecutar cada comando en los  
scripts uno por uno en su lugar.

### Estructura del repositorio

main.cu simplemente analiza los argumentos y llama a los filtros necesarios  
stb_image/ contiene la biblioteca de imágenes que utilizamos.  
image.h es nuestro envoltorio para la biblioteca de imágenes.  
filters/ contiene cada filtro implementado en un archivo de encabezado  
filters/convolve.h es llamado desde cada filtro de convolución.  
Otros filtros tienen sus propios kernels.  
images/lena_rgb.png es la imagen de entrada para todos nuestros casos de prueba.

### Introducción

Nota: Debes tener la capacidad de ejecutar archivos CUDA en tu sistema para poder renderizar cualquier trabajo en este repositorio. Para obtener más información sobre CUDA, visita este enlace: [https://developer.nvidia.com/about-cuda](https://developer.nvidia.com/about-cuda)

Antes de que se puedan aplicar filtros, el archivo `main.cu` debe ser compilado. Para hacerlo, abre tu terminal y ejecuta el siguiente comando desde el directorio de este proyecto:

`nvcc main.cu`
