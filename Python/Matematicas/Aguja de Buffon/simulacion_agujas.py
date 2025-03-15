# -*- coding: utf-8 -*-
"""
Created on Fri Mar 14 18:54:25 2025

@author: SciData
"""

import numpy as np
import pandas as pd
from plotnine import *

def lanzamientos(N):
    x0 = np.random.uniform(0, 10, N)
    theta = np.random.uniform(0, 2 * np.pi, N)
    
    def contar_exitos(n):
        resultados = (n - x0) / np.cos(theta)
        exitos = (resultados > 0) & (resultados <= 1)
        return exitos.sum()
    
    return np.array([contar_exitos(n) for n in range(11)])

datos = pd.DataFrame({"N": np.arange(10000, 1000000, 5000)})
datos["estimacion"] = datos["N"].apply(lambda x: 2 * x / lanzamientos(x).sum())

p = (
    ggplot(datos, aes(x="N", y="estimacion")) +
    geom_line(size=3, alpha=0.3, color="#E69F00") +
    geom_line(size=1, color="#E69F00") +
    geom_hline(yintercept=np.pi, size=3, alpha=0.3, color="red") +
    geom_hline(yintercept=np.pi, size=1, color="red") +
    scale_x_log10() +
    theme(
        panel_background=element_rect(fill="#202020"),
        panel_grid=element_line(color="darkgrey", size=0.1),
        axis_title=element_blank()
    )
)
p
