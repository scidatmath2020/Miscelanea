library(tidyverse)
setwd("C:\\Users\\Usuario\\Documents\\scidata\\24_vis_r_py\\trabajos")

velocistas = read.csv("velocistas.csv")
velocistas_promedios = read.csv("velocistas_promedios.csv")

# Definiendo las etiquetas de las facetas
nombres_facetas <- c(female="Mujeres",male="Hombres")

# Crear el gráfico
ggplot() +
  geom_point(data=velocistas,
             mapping=aes(x=anio,
                         y=tiempo,
                         color=factor(anio)),
             size=2) +
  geom_point(data=velocistas_promedios,
             mapping=aes(x=anio,
                         y=promedio,
                         color=factor(anio)),
             size=3.5,
             alpha=0.3) +
  geom_text(data=velocistas_promedios,
            mapping=aes(x=anio,
                        y=9.5,
                        label=round(promedio,2),
                        color=factor(anio)),
            size=2,
            fontface="bold") +
  scale_x_continuous(breaks = seq(1968,2020,4)) +
  ylim(9.4, 11.5) +
  labs(title = "Tiempos de medallistas en 100m en JJOO", 
       subtitle = "Se presenta segregación por sexo, año y promedio",
       x = "Año",
       y = "Tiempo (s)") +
  theme(legend.position = "none", #Eliminar barra de colores
        axis.text.x = element_text(angle = 45, hjust = 1),#inclinar texto en ticks
        panel.background=element_blank(),#Blanquear fondo
        panel.border = element_rect(color = "black", # Recuadro del gráfico
                                    fill = NA, 
                                    linewidth = 1),
        strip.text = element_text(color = "black", #Formato de título de facetas en caso de haber
                                  size = 12, 
                                  face = "bold"),
        strip.background = element_rect(color = "black", #Formato del recuadro de título de facetas
                                        fill = "gold", 
                                        size = 1.5)
  ) +
  facet_wrap(~sexo,
             ncol=2,
             labeller = as_labeller(nombres_facetas)) #Nombre de las facetas