# -*- coding: utf-8 -*-
"""
Created on Wed Feb 14 13:51:39 2024

@author: Usuario
"""

import numpy as np
import pandas as pd
from plotnine import *

#%%
t_c = np.arange(0, 2*np.pi+0.01,0.01)

corazon = pd.DataFrame({"x" : 16*np.sin(t_c)**3,
                        "y": 16*np.cos(t_c)-5*np.cos(2*t_c)-2*np.cos(3*t_c)-np.cos(4*t_c),
                        "tipo" :len(t_c)*["c"]})

constructor = lambda x: x-2-2*np.floor((x-1)/2)

t_f = np.arange(0,12*np.pi+0.01,0.01)
flor = pd.DataFrame({"x" : 3*np.cos(t_f)*(abs(6*constructor(9*t_f/(4*np.pi)))-4.5),
                     "y" : 3*np.sin(t_f)*(abs(6*constructor(9*t_f/(4*np.pi)))-4.5),
                     "tipo" : len(t_f)*["f"]})

datos = pd.concat([corazon,flor])

(
ggplot(data = datos) +
    geom_point(mapping = aes(x="x",y="y",color="tipo"),
               alpha=0.1,size=3) +
    geom_point(mapping = aes(x="x",y="y",color="tipo"),
               size=0.7) +
    scale_color_manual(values=["red","#00FF00"]) +
    theme(
    panel_background = element_rect("#202020"), 
    panel_grid = element_blank(),
    axis_title = element_blank(), 
    axis_text = element_blank(), 
    axis_ticks = element_blank()
  )
 )



