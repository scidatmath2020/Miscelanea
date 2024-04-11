# -*- coding: utf-8 -*-
"""
Created on Thu Apr 11 09:40:49 2024

@author: Usuario
"""

import math
from siuba import *
from plotnine import *
import numpy as np
import pandas as pd

delta = 0.0000001
c_x = 25

while True:
    h = c_x
    c_y = (147-5*h)/4
    r = (41*(h**2-30*h+369)/16)**0.5
    theta = math.acos((2*r**2-1476)/(2*r**2))
    if abs(r*theta-42)<=0.0000001:
        break
    c_x = c_x + delta
    
T =  np.linspace(0, 2*math.pi,num=1000)

mis_datos = pd.DataFrame({"abscisas":r*np.cos(T)+c_x,"ordenadas":r*np.sin(T)+c_y})
otros = pd.DataFrame({"abscisas":[0,30,c_x],"ordenadas":[6,30,c_y]})



(ggplot() +
    geom_point(data=mis_datos,mapping=aes(x="abscisas",y="ordenadas")) +
    geom_point(data=otros,mapping=aes(x="abscisas",y="ordenadas"),color="red") +
    geom_segment(aes(x=[c_x,c_x],y=[c_y,c_y],xend=[0,30],yend=[6,30]),color="red")
)

print(f"El centro es ({c_x},{c_y}) y el radio es {r}")
