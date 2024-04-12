# Cargamos nuestra paqueter?a.
library(tidyverse)
library(gganimate)

##############################################################################
##############################################################################


### Ruta donde se guarda el archivo de Mexico_divison_politica.csv
setwd("C:\\Users\\Usuario\\Documents\\scidata\\miscelanea\\R\\analisis_de_datos\\animacion_colorear_mapa")
mexico_div <- read.csv("Mexico_division_politica.csv")
mex <- mexico_div %>% mutate(ent = as.integer(Grupo))

datos = lapply(1:10,function(x){exp(runif(32))})

constructor = function(x){
  mi_data = data.frame(datos[[x]])
  mi_data$año = x
  mi_data$ent = 1:32
  mi_mex = mex %>% left_join(mi_data)
  return(mi_mex)
}

resultado = lapply(1:10,constructor)

final = do.call(rbind,resultado)

names(final)[5]="Valores"

p = ggplot(data = final) +
  geom_polygon(mapping=aes(x=Longitud,y=Latitud,group=Grupo,fill=Valores),color="black") +
  theme(legend.position="top",
        panel.background = element_rect("#202020"), 
        panel.grid = element_blank(),
        axis.title = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(),
        plot.title = element_text(face="bold.italic"))



anim = p + transition_time(año) + labs(title="Año: {frame_time}") 

animate(anim, width = 600, height = 600)





