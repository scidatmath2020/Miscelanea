# Cargamos nuestra paqueter�a.
library(tidyverse)

##############################################################################
##############################################################################


# Mostramos las autoridades por las cuales se pregunta a los encuestados
descripcion_autoridades = c("Tr�nsito municipal",
                            "Polic�a municipal",
                            "Polic�a Estatal",
                            "Guardia Nacional",
                            "Polic�a Ministerial",
                            "Ministerio_P�blico\nFiscal�as",
                            "FGR",
                            "Ej�rcito",
                            "Marina",
                            "Jueces")


##############################################################################
##############################################################################


# Cargamos la tabla que contiene la informaci�n donde se encuentran las columnas de inter�s.
load("tper_vic.RData")

# De la tabla cargada, seleccionamos �nicamente las columnas de nuestro inter�s:
##### CVE_ENT: clave de la entidad.
##### Familia AP5_03_X: reconocimiento de la autoridad.
##### Familia AP5_05_X: percepci�n de la autoridad acerca de la corrupci�n.
##### FAC_ELE: factor de elecci�n.

corrupcion <- tper_vic %>% select(CVE_ENT,
                                  starts_with("AP5_3"),
                                  starts_with("AP5_5"),
                                  FAC_ELE)


##############################################################################
##############################################################################


extraer <- function(x){
  auxiliar = corrupcion[,c(1,x,x+10,22)]
  names(auxiliar)[2:3] = c("reconocimiento","corrupcion")
  return(auxiliar)
}

autoridades <- lapply(2:11,extraer)


resumen  <- function(tabla){ 
  auxiliar = tabla %>% 
    filter(reconocimiento == 1) %>%
    mutate(corrupcion = ifelse(corrupcion==1,1,0)) %>%
    summarize(porcentaje_corrupcion = sum(corrupcion*FAC_ELE)*100/sum(FAC_ELE))
  return(auxiliar)
}


estatal_calcular_por_autoridad <- function(x){
  autoridades[[x]] %>% 
    group_by(CVE_ENT) %>% 
    resumen() %>%
    ungroup() %>%
    mutate(autoridad = descripcion_autoridades[x]) %>%
    rename(ent=CVE_ENT)
}


estatal_tablas_autoridades = lapply(1:10,estatal_calcular_por_autoridad)
estatal_tabla_corrupcion_final = do.call(rbind,estatal_tablas_autoridades)


##############################################################################
##############################################################################


mexico_div <- read.csv("Mexico_division_politica.csv")
mex <- mexico_div %>% mutate(ent = as.integer(Grupo))
mapa <- left_join(mex,estatal_tabla_corrupcion_final)


##############################################################################
##############################################################################


ggplot() +
  geom_polygon(data = mapa,
               mapping = aes(x=Longitud,
                             y=Latitud,
                             group=Grupo,
                             fill=porcentaje_corrupcion),
               size = .05) +
  scale_fill_gradient(low = "yellow",
                      high = "darkred",
                      na.value = NA,
                      name="Porcentaje de mayores de edad\nque perciben corrupci�n en la autoridad") +
  coord_map(xlim=c(-117,-87),
            ylim=c(14,32)) +
  theme(legend.position="top",
        panel.background = element_rect("#202020"), 
        panel.grid = element_blank(),
        axis.title = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(),
        plot.title = element_text(face="bold.italic")
  ) +
  facet_wrap(.~autoridad,ncol=5) +
  labs(title = "Poblaci�n de 18 a�os y m�s que identifica a las autoridades de seguridad\np�blica por entidad federativa y tipo de autoridad,\nseg�n percepci�n de corrupci�n\nmarzo y abril de 2022", 
       subtitle = "Fuente: ENVIPE 2022, INEGI")