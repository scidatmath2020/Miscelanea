# -*- coding: utf-8 -*-
"""
Created on Fri Mar 14 18:59:23 2025

@author: SciData
"""

import numpy as np
import pandas as pd
from plotnine import *

# Generación de datos
np.random.seed(42)
n = 500
x0 = np.random.uniform(0, 10, n)
y0 = np.random.uniform(0, 10, n)
theta = np.random.uniform(0, 2 * np.pi, n)

# Cálculo de los puntos finales
xf = x0 + np.cos(theta)
yf = y0 + np.sin(theta)

# DataFrame con los valores generados
prueba = pd.DataFrame({"x0": x0, "y0": y0, "xf": xf, "yf": yf, "theta": theta})

# Evaluar intersecciones con líneas verticales en x = 0,1,2,...,10
x_values = np.arange(0, 11)
M = np.array([
    ((x >= prueba["x0"]) & (x <= prueba["xf"])) | ((x <= prueba["x0"]) & (x >= prueba["xf"]))
    for x in x_values
]).astype(int).T  # Transponer para obtener una matriz de n x 11

# Sumar intersecciones por segmento
prueba["resultado"] = np.sum(M, axis=1).astype(str)  # Convertir a string para categorización en plot
prueba["resultado"] = prueba["resultado"].astype("category")

# Graficar
p = (
    ggplot(prueba)
    + geom_segment(aes(x="x0", y="y0", xend="xf", yend="yf", color="resultado"), size=1)
    + geom_vline(xintercept=x_values, color="black")
    + scale_color_manual(values={"0": "#FF0000", "1": "darkgreen"})
    + theme(
        panel_background=element_rect(fill="#ADD8E6"),
        panel_grid=element_blank(),
        axis_title=element_blank()
    )
)

p
