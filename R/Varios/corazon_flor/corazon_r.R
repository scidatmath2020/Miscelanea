library(tidyverse)

t_c = seq(0,2*pi,0.01)
corazon = data.frame(x=16*sin(t_c)^3,
                     y=13*cos(t_c)-5*cos(2*t_c)-2*cos(3*t_c)-cos(4*t_c),
                     tipo="c")

t_f = seq(0,12*pi,0.01)
flor = data.frame(x=3*cos(t_f)*(abs(6*constructor(9*t_f/(4*pi)))-4.5),
                  y=3*sin(t_f)*(abs(6*constructor(9*t_f/(4*pi)))-4.5),
                  tipo="f")

constructor = function(x){return(x-2-2*floor((x-1)/2))}

datos = rbind(corazon,flor)

ggplot(data=datos)+
  geom_point(mapping=aes(x=x,y=y,color=tipo),
             alpha=0.1,size=3)+
  geom_point(mapping=aes(x=x,y=y,color=tipo),
             size=0.7) +
  scale_color_manual(values=c("red", "green")) +
  theme(
    panel.background = element_rect("#202020"), 
    panel.grid = element_blank(),
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank()
  )