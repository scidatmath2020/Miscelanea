library(tidyverse)
library(grid)
library(gganimate)
library(latex2exp)

fantasma = data.frame(x=seq(-13,13,0.1),y=dnorm(seq(-13,13,0.1),sd=4))
ojos = data.frame(x=c(-1,1),y=c(0.075,0.075))
boca = data.frame(x=0,y=(0.075+0.05)/2)
falda = data.frame(x=seq(-13,13,26/6),y=c(0,-0.0125,0,-0.0125,0,-0.0125,0))

mis_iris = function(t){
    return(data.frame(x=c(-1+0.3*cos(t),1+0.3*cos(t)),y=c(0.075,0.075),tiempo=t))
}

IRIS_1 = lapply(seq(pi,2*pi,0.01),mis_iris)
IRIS_1 = do.call(rbind,IRIS_1)

IRIS_2 = lapply(seq(2*pi,3*pi,0.01),mis_iris)
IRIS_2 = do.call(rbind,IRIS_2)

IRIS = rbind(IRIS_1,IRIS_2)

gaussiana = data.frame(x=c(9,-8.5),y=c(0.09,0.09),texto=c(r"($f_X(x)=\frac{1}{4\sqrt{\pi}}e^{-x^2/32}$)",r"($X\sim N(\mu=0,sd=4)$)"))


animacion = ggplot() +
  annotation_custom(rasterGrob(colorRampPalette(c("black", "white"))(100), 
                               width = unit(1, "npc"), 
                               height = unit(1, "npc")),
                    xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_text(data=gaussiana,mapping=aes(x=x,y=y,label=TeX(texto,output="character")),
            parse=TRUE,
            color="white",
            size=18/.pt)+
  geom_area(data=fantasma,mapping=aes(x=x,y=y),color="black",fill="white") +
  geom_point(data=ojos,mapping=aes(x=x,y=y),size=7,shape=21,fill="white") +
  geom_point(data=IRIS,mapping=aes(x=x,y=y),size=4) +
  geom_point(data=boca,mapping=aes(x=x,y=y),size=10) +
  geom_line(data=falda,mapping=aes(x=x,y=y),linewidth=0.8) +
  geom_ribbon(data=falda,mapping=aes(x=x,ymin = y, ymax = 0), fill = "white") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = NA, color = NA), 
        plot.background = element_rect(fill = NA, color = NA)) +
  transition_time(tiempo)

animacion_final <- animate(animacion, duration = 2) 
animacion_final