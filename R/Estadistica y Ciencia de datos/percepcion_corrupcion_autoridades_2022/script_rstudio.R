# Cargamos nuestra paquetería.
library(tidyverse)

##############################################################################
##############################################################################


# Mostramos las autoridades por las cuales se pregunta a los encuestados
descripcion_autoridades = c("Tránsito municipal",
                            "Policía municipal",
                            "Policía Estatal",
                            "Guardia Nacional",
                            "Policía Ministerial",
                            "Ministerio_Público\nFiscalías",
                            "FGR",
                            "Ejército",
                            "Marina",
                            "Jueces")


##############################################################################
##############################################################################


# Cargamos la tabla que contiene la información donde se encuentran las columnas de interés.
load("tper_vic.RData")

# De la tabla cargada, seleccionamos únicamente las columnas de nuestro interés:
##### CVE_ENT: clave de la entidad.
##### Familia AP5_03_X: reconocimiento de la autoridad.
##### Familia AP5_05_X: percepción de la autoridad acerca de la corrupción.
##### FAC_ELE: factor de elección.

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
                      name="Porcentaje de mayores de edad\nque perciben corrupción en la autoridad") +
  coord_map(xlim=c(-117,-87),
            ylim=c(14,32)) +
  theme(legend.position="top",
        panel.background = element_rect("#202020"), 
        panel.grid = element_blank(),
        axis.title = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank()
  ) +
  facet_wrap(.~autoridad,ncol=5) 