# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

| Integrante | github nick |
|------------|-------------|
| Crisitan Danilo Ramirez Vargas | [rvcristiand](https://github.com/rvcristiand) |
| Edward Camilo Carrillo Estupinan  | [eccarrilloe] (https://github.com/eccarrilloe) |

## Discusión

### Anti-aliasing
A cada **punto** de la **grilla** se le asoció una **subgrila**, del tamaño de un recuadro la grilla original, con *2^(nn - 1)* divisiones en *x* y en *y* (*nn* puede variar de 1 a 3 al presionar las teclas *arriba* y *abajo*). En función de la relación entre el número de subpuntos dentro del triángulo y el total de subpuntos asociado a cada punto se asigna la variable [*alpha*](https://processing.org/reference/alpha_.html) a la función [*stroke*] (https://processing.org/reference/stroke_.html).

Esta método está basado en el presentado en [scratchapixel] (https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation).

Como resultado se obtiene un triángulo con bordes suaves. Para obtener un efecto visual más impresionante, se debe aunmentar el número de divisiones de la grilla, para lo cual se ha modificado el código para que se pueda llegar a divisiones hasta de 2^10.

### Shading
A cada punto de la grilla, que está dentro del triángulo, se le calculó el peso asociado a cada vértice del triángulo y, a su vez, a cada vértice  se le asoció un color (rojo, verde y azul). Una vez obtenido estos valores se calcula el porcentaje de rojo, verde y azul que le corresponde a cada punto dentro del triángulo.

Este método está basado en el presentado en [The ryg blog] (https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/).

Como resultado se obtiene: primero, determinar si un punto está dentro del triángulo y, segundo, interpolar varios valores de los vértices en dichos puntos. Para obtener un efecto visual más impresionante, se debe aumentar el número de divisiones de la grilla.

### Dificultades
La dificultad más grande al momento de implimentar estos algoritmos fue el entendimiento de la librería [frames] (https://github.com/VisualComputing/framesjs), puesto es el primer acercamiento.
