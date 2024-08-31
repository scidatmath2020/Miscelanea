# -*- coding: utf-8 -*-
"""
Created on Sat Aug 31 11:48:49 2024

@author: Usuario
"""

import numpy as np
import pandas as pd
from siuba import *
from siuba.dply.vector import *
from plotnine import *
import os

os.chdir("C:\\Users\\Usuario\\Documents\\scidata\\miscelanea\\python\\otros\\demografia")

demografia = pd.read_csv("demografia.csv")
mexico = pd.read_csv("mex_div_pol.csv",
                  encoding="latin1")

demografia = (demografia >> 
    mutate(poblacion_relativa = (_.POBTOT - _.POBTOT.min())/(_.POBTOT.max() - _.POBTOT.min())))

#%%

################# Mapa con color uniforme
(ggplot() + 
  geom_polygon(data=mexico,
             mapping=aes(x="Longitud",y="Latitud",group="Grupo"),
             color="black",
             fill="#C2C4C1",
             size=0.1) +
  geom_point(data=demografia,
             mapping=aes(x="LONGITUD_DECIMAL",y="LATITUD_DECIMAL",
                         alpha="poblacion_relativa"),
             color = "#1D1C9F",
             shape = "+",
             size=0.000000001) +
  geom_polygon(data=mexico,
             mapping=aes(x="Longitud",y="Latitud",group="Grupo"),
             color="black",
             fill=None,
             size=0.1) +
   theme(legend_position = "none",
        panel_background=element_rect(fill="white"),
        axis_ticks=element_blank(),
        axis_text=element_blank(),
        axis_title=element_blank()))


################# Mapa con color dependiente de la entidad
(ggplot() + 
  geom_polygon(data=mexico,
             mapping=aes(x="Longitud",y="Latitud",group="Grupo"),
             color="black",
             fill="#C2C4C1",
             size=0.1) +
  geom_point(data=demografia,
             mapping=aes(x="LONGITUD_DECIMAL",y="LATITUD_DECIMAL",
                         alpha="poblacion_relativa",color="ENTIDAD"),
             #color = "#1D1C9F",
             shape = "+",
             size=0.000000001) +
  geom_polygon(data=mexico,
             mapping=aes(x="Longitud",y="Latitud",group="Grupo"),
             color="black",
             fill=None,
             size=0.1) +
   theme(legend_position = "none",
        panel_background=element_rect(fill="white"),
        axis_ticks=element_blank(),
        axis_text=element_blank(),
        axis_title=element_blank()))




