################################################
############ Cargado de paqueter�a #############
################################################

### Para utilizar el graficador ggplot2
library(tidyverse)

### Para poder escribir con LaTeX en las leyendas de los gr�ficos 
library(latex2exp)

################################################
######## Lectura de los csv de inter�s #########
################################################

## Todas las tablas se encuentran en la carpeta de data

sismos <- read.csv("sismos.csv")
placas_mex <- read.csv("Mexico_placas_tectonicas.csv")
mex_div_politica <- read.csv("Mexico_division_politica.csv")

################################################
######## Gr�fica de sismos por zona ############
################################################

ggplot() +
  geom_point(sismos, mapping = aes(x=Longitud,y=Latitud,color=Zona),alpha=0.1) +
  geom_polygon(mex_div_politica, mapping = aes(x=Longitud, y=Latitud, group=Grupo), fill=NA,color = "black", size = .2) +
  geom_path(placas_mex,mapping = aes(x=Longitud,y=Latitud,group=Tipo),color = "brown",size=1) +
  coord_map(ylim=c(10,35)) 

################################################
#######         Gr�fica de sismos        #######
####### con l�mites de placas tect�nicas #######
################################################

#### Comentarios: 
#### 1) Se realizan dos capas de divisi�n pol�tica. La segunda no tiene color de relleno
####    en las entidades, pues solo se busca que aparezca sobre la capa de puntos de sismos.

ggplot() +
  # Capa de divisi�n pol�tica
  geom_polygon(mex_div_politica, mapping = aes(Longitud, Latitud, group=Grupo), fill = "#303030", color = "#505050", size = .2) +
  # Capa de puntos de sismos
  geom_point(sismos, mapping = aes(x=Longitud,y=Latitud),size = 0.5, color = "#E69F00",alpha=0.5) +
  # Capa de divisi�n pol�tica
  geom_polygon(mex_div_politica, mapping = aes(Longitud, Latitud, group=Grupo), fill = NA, color = "#505050", size = .2) +
  # Capa de l�mites de las placas tect�nicas
  geom_path(placas_mex,mapping = aes(x=Longitud,y=Latitud,group=Tipo),size = 1.5, color = "#009E73", alpha = 0.7) +
  # Ajuste de coordenadas
  coord_map(xlim=c(-120,-85),ylim=c(10,35))+
  # Tema negro
  theme(
    panel.background = element_rect("#202020"), 
    panel.grid = element_blank(),
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank()
  ) +
  # Capa de t�tulos
  labs(title = "Sismos y Placas Tect�nicas en M�xico", subtitle = "Desde el a�o 1900") +
  geom_point(aes(-119, 23), size = 3, color = "#009E73", alpha = 0.7) +
  geom_text(aes(-118, 23), label = "Placas tect�nicas", color = "#009E73", hjust = 0, alpha = 1) +
  geom_point(aes(-119, 22), size = 3, color = "#E69F00", alpha = 0.7) +
  geom_text(aes(-118, 22), label = "Sismo", color = "#E69F00", hjust = 0, alpha = 1)
  
################################################
#######         Gr�fica de sismos        #######
#######        con magnitud >= 6.5       #######
####### con l�mites de placas tect�nicas #######
################################################

#### Comentarios: 
#### 1) Se realizan dos capas de divisi�n pol�tica. La segunda no tiene color de relleno
####    en las entidades, pues solo se busca que aparezca sobre la capa de puntos de sismos.
#### 2) Se realizan dos capas de puntos de sismos. La primera tiene menor tama�o y menos transparencia
####    que la segunda para hacer un efecto de iluminaci�n.
#### 3) Se utiliza el s�mbolo de LaTeX para >= (\geq) en el t�tulo del gr�fico.

sismos_fuertes <- sismos[sismos$Magnitud>=6.5,]

ggplot() +
  # Capa de divisi�n pol�tica
  geom_polygon(mex_div_politica, mapping = aes(x=Longitud, y=Latitud, group=Grupo), fill = "#303030", color = "#505050", size = .2) +
  # Capa de puntos de sismos
  geom_point(sismos_fuertes, mapping = aes(x=Longitud,y=Latitud),size = 2, color = "#E69F00",alpha=0.5) +
  # Capa de puntos de sismos
  geom_point(sismos_fuertes, mapping = aes(x=Longitud,y=Latitud),size = 3, color = "#E69F00",alpha=0.1) +
  # Capa de divisi�n pol�tica
  geom_polygon(mex_div_politica, mapping = aes(x=Longitud, y=Latitud, group=Grupo), fill = NA, color = "#505050", size = .2) +
  # Capa de l�mites de las placas tect�nicas
  geom_path(placas_mex,mapping = aes(x=Longitud,y=Latitud,group=Tipo),size = 1.5, color = "#009E73", alpha = 0.7) +
  # Ajuste de coordenadas
  coord_map(xlim=c(-120,-85),ylim=c(10,35))+
  # Tema negro
  theme(
    panel.background = element_rect("#202020"), 
    panel.grid = element_blank(),
    axis.title = element_blank(), 
    axis.text = element_blank(), 
    axis.ticks = element_blank()
  ) +
  # Capa de t�tulos
  labs(title = TeX("Sismos y Placas Tect�nicas en M�xico (Magnitud $\\geq$ 6.5)"), subtitle = "Desde el a�o 1900") +
  geom_point(aes(-119, 23), size = 3, color = "#009E73", alpha = 0.7) +
  geom_text(aes(-118, 23), label = "Placas tect�nicas", color = "#009E73", hjust = 0, alpha = 1) +
  geom_point(aes(-119, 22), size = 3, color = "#E69F00", alpha = 0.7) +
  geom_text(aes(-118, 22), label = "Sismo", color = "#E69F00", hjust = 0, alpha = 1)
