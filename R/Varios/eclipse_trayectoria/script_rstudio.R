# Cargamos nuestra paqueter?a.
library(tidyverse)
library(gganimate)

##############################################################################
##############################################################################


### Ruta donde se guarda el archivo de Mexico_divison_politica.csv
setwd("C:\\Users\\Usuario\\Documents\\scidata\\miscelanea\\R\\otros\\trayecto_ecipse")
mexico_div <- read.csv("Mexico_division_politica.csv")
mex <- mexico_div %>% mutate(ent = as.integer(Grupo))

pendiente = 123514/117705
ordenada_origen = 105202252923/784700000

####
## recta: y=pendiente*x+ordendada_origen
## recta: pendiente*x-y+ordenada_origen=0
## distancia (u,v) a recta: d=|pendiente*u-v+ordenada_origen|/sqrt(pendiente^2+1)


malla_x = seq(-117,-87,by=1)
malla_y = seq(14,32,by=1)

malla = expand.grid(malla_x,malla_y)
malla = as.data.frame(malla)
colnames(malla) = c("u","v")

malla = malla %>% mutate(distancia = abs(pendiente*u-v+ordenada_origen)/sqrt(pendiente^2+1))

trayectoria = data.frame(abscisa = seq(-106.5,-100,by=1)) 
trayectoria = trayectoria %>% mutate(ordenada=pendiente*abscisa+ordenada_origen,indice=1:nrow(trayectoria))


##############################################################################
##############################################################################


p = ggplot() +
  geom_point(data=malla,mapping=aes(x=u,y=v,color=distancia),size=20) +
  scale_color_gradient(low="black",high="blue")+
  geom_polygon(data = mex,
               mapping = aes(x=Longitud,
                             y=Latitud,
                             group=Grupo,
                             ),color="white",fill=NA,
               size = .05) +
  geom_point(data=trayectoria,mapping=aes(x=abscisa,y=ordenada),size=10,color="yellow")+
  geom_point(data=trayectoria,mapping=aes(x=abscisa,y=ordenada),size=7,color="black") +
  coord_map(xlim=c(-117,-87),
            ylim=c(14,32)) +
  theme(legend.position="top",
        panel.background = element_rect("#202020"), 
        panel.grid = element_blank(),
        axis.title = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(),
        plot.title = element_text(face="bold.italic")
  )  

p + transition_time(trayectoria$indice) 
