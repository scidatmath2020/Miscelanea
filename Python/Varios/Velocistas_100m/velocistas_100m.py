# -*- coding: utf-8 -*-
"""
Created on Wed Aug  7 12:12:10 2024

@author: Usuario
"""

import pandas as pd
from plotnine import *
import os

os.chdir("C:\\Users\\Usuario\\Documents\\scidata\\24_vis_r_py\\trabajos")

velocistas = pd.read_csv("velocistas.csv")
velocistas_promedios = pd.read_csv("velocistas_promedios.csv")

#%%


# Suponiendo que 'velocistas' y 'velocistas_promedios' son DataFrames de pandas con las columnas adecuadas

# Definiendo las etiquetas de las facetas
nombres_facetas = {'female':'Mujeres', 'male':'Hombres'}

# Crear el gráfico con plotnine
(
ggplot() +
     geom_point(data=velocistas, 
                mapping=aes(x='anio', 
                            y='tiempo', 
                            color='factor(anio)'), 
                size=2) +
     geom_point(data=velocistas_promedios, 
                mapping=aes(x='anio', 
                            y='promedio', 
                            color='factor(anio)'), 
                size=3.5, 
                alpha=0.3) +
     geom_text(data=velocistas_promedios, 
               mapping=aes(x='anio', 
                           y=9.5, 
                           label='round(promedio, 2)', 
                           color='factor(anio)'), 
               size=6, 
               fontweight='bold',
               angle=90) + #inclinación del texto
     scale_x_continuous(breaks=range(1968, 2024, 4)) + 
     ylim(9.4, 11.5) +
     labs(title="Tiempos de medallistas en 100m en JJOO", 
          subtitle="Se presenta segregación por sexo, año y promedio",
          x="Año", 
          y="Tiempo (s)") +
     theme(legend_position="none", #Eliminar barra de colores
           axis_text_x=element_text(angle=45, hjust=1,size=6), #inclinar texto en ticks
           panel_background=element_blank(), #Blanquear fondo
           panel_border=element_rect(color='black', # Recuadro del gráfico
                                     size=1),
           strip_text = element_text(color = "black", #Formato de título de facetas en caso de haber
                                  size = 12, 
                                  face = "bold"),
           strip_background = element_rect(color = "black", #Formato del recuadro de título de facetas
                                        fill = "gold", 
                                        size = 1.5)) +
     facet_wrap('~sexo', 
                ncol=2, 
                labeller=labeller(cols=nombres_facetas)  #Nombre de las facetas
                )
)

