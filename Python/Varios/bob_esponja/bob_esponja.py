# -*- coding: utf-8 -*-
"""
Created on Sat Nov 23 21:43:53 2024

@author: Usuario
"""

import pandas as pd
import numpy as np

from plotnine import *

import os

ruta = "C:/Users/Usuario/Documents/scidata/24_st"
os.chdir(ruta)

bob = pd.read_csv("bob.csv",header=None)

bob_long = bob.reset_index().melt(id_vars="index", var_name="col", value_name="value")
bob_long.rename(columns={"index": "row"}, inplace=True)

(
    ggplot(bob_long, aes(x="col", y="row", fill="value")) +
    geom_tile() +
    scale_fill_gradient(low="black", high="white") +  
    scale_y_reverse() +  # Invertir el eje y para que la imagen no esté de cabeza
    theme_void() +  
    coord_equal()   
)












