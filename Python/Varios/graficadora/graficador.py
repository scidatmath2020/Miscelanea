# -*- coding: utf-8 -*-
"""
Created on Thu Apr 25 23:51:46 2024

@author: Usuario
"""

import pandas as pd
import numpy as np
from siuba import *
from plotnine import *

#%%

y_func = lambda x,t: np.sin(t*x)/x
y_limit = lambda t: y_func(0.0000000001,t)

x_valores = np.linspace(-2*np.pi, 2*np.pi,400)
t_valores = [1,2,3]

#%%

resultados = [pd.DataFrame({"abscisas":x_valores,
               "valores":y_func(x_valores,t),
               "t":len(x_valores)*[f"{t}"]}) for t in t_valores]

limites = pd.DataFrame({"abscisas":3*[0],
 "valores":[y_limit(t) for t in t_valores],
 "t":[f"{t}" for t in t_valores]}) >> mutate(desplazamiento=_.valores+0.1,
                                             texto=[r'$\lim_{{x \to 0}} \frac{{\sin(x)}}{{x}}=1$',
                                                    r'$\lim_{{x \to 0}} \frac{{\sin(2x)}}{{x}}=2$',
                                                    r'$\lim_{{x \to 0}} \frac{{\sin(3x)}}{{x}}=3$'])

etiquetas_x = pd.DataFrame({"x_valores":[-2*np.pi,-np.pi,0,np.pi,2*np.pi],
                            "texto":[u"-2π",u"-π","0",u"π",u"2π"]})

y_ticks = np.arange(-1,3.5,0.5)

etiquetas_y = pd.DataFrame({"y_valores":y_ticks ,
                            "texto":y_ticks})

resultados = pd.concat(resultados)

#%%
(
ggplot() + 
    geom_line(data=resultados,mapping=aes(x="abscisas",y="valores",color="t")) +
    geom_point(data=limites,mapping=aes(x="abscisas",y="valores",color="t")) +
    ggtitle(title="Gráfica de y=sin(tx)/x para diferentes valores de t\ncon el límite en x=0") +
    annotate("text",x=[2.5,2.5,2.5],y=limites.desplazamiento, label=limites.texto, size=12)+
    geom_segment(data=limites,mapping=aes(x=[1.2,1.2,1.2],y="desplazamiento",xend=0.2,yend="valores"),arrow=arrow(4),size=1) +
    geom_text(data=etiquetas_x,mapping=aes(x=[k*np.pi for k in range(-2,3)],y=-0.4,label="texto")) +
    geom_segment(data = etiquetas_x, mapping = aes(x = "x_valores", y = 0, xend = "x_valores", yend = -0.2), color = "black") +
    geom_text(data=etiquetas_y,mapping=aes(x=-0.7,y="y_valores",label="texto")) +
    geom_segment(data = etiquetas_y, mapping = aes(x = 0, y = "y_valores", xend = -0.2, yend = "y_valores"), color = "black") +
    geom_segment(aes(x = -float('inf'), y = 0, xend = float('inf'), yend = 0), color = "black") +  # Eje X
    geom_segment(aes(x = 0, y = -float('inf'), xend = 0, yend = float('inf')), color = "black") +
    scale_color_manual(values=["#377699","#E69C46","#679765"]) +
    scale_x_continuous(breaks=None,labels=None) +
    scale_y_continuous(breaks=None,labels=None) +
    theme(axis_title_x=element_blank(), axis_title_y=element_blank(),panel_background = element_rect("white"))    
)



