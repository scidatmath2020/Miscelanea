library(ggplot2)
library(jpeg)
library(ggpubr)
library(gganimate)

## ruta donde se descarga el archivo sol.jpg
setwd("C:\\Users\\Usuario\\Documents\\scidata\\miscelanea\\R\\otros\\eclipse")

## Leer la imagen del sol
img = readJPEG("sol.jpg")

## Crear las lunas
mi_data = data.frame(indice = 1:11,
                     centro = -5:5,
                     y=0)

## Gráfico sin animación
p = ggplot(mi_data, aes(centro, y)) +
  background_image(img) +
  geom_point(color="black",size=80) +
  xlim(-5,5) +
  ylim(-5,5)

## Crear animación
p + transition_time(indice)





