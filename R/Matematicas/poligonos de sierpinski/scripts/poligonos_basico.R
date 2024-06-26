################################################
################################################
############  Este script genera los  ##########
############ pol�gonos de Sierpinski  ##########
############ para 3,4,5,6,7 y 8 lados ##########
############      con radio 2/3       ##########
################################################
################################################


################################################
############ Cargado de paqueter�a #############
################################################

#### Cargamos nuestro graficador ggplot2
library(ggplot2)

################################################
########### Construimos un pol�gono ############
###########        de N lados       ############
################################################


constructor_poligono <- function(N){
  exponentes <- 0:(N-1)
  poligono <- data.frame(a1 = cos(2*pi*exponentes/N),
                         a2 = sin(2*pi*exponentes/N))
  return(poligono)
}


#####################################################################
###########              Construimos un pol�gono             ########
###########                    de N lados                    ########
###########            y seleccionamos un v�rtice.           ########
###########           Nos dirigimos a ese v�rtice            ########
###########          pero nos detenemos a 2/3 antes.         ########
########### Elegimos un nuevo v�rtice y repetimos el proceso ########
#####################################################################

simulacion <- function(vertices){
  poligono <- constructor_poligono(vertices)
  punto_n <- function(u,v,r){
    vertice <- poligono[sample(1:nrow(poligono),1),]
    coor_x <- (r*u+vertice[1])/(r+1)
    coor_y <- (r*v+vertice[2])/(r+1)
    return(c(coor_x, coor_y))
  }

  x0 = poligono[1,1]
  y0 = poligono[1,2]
  X = c(x0)
  Y = c(y0)

  for(i in 1:15000){
    pn <- punto_n(X[i],Y[i],2/3)
    X <- c(X,pn[[1]])
    Y <- c(Y,pn[[2]])
  }
  
  return(data.frame(X,Y,nver = as.factor(nrow(poligono))))
}


##############################################################
###########      Realizamos el proceso anterior    ###########
########### para pol�gonos de 3,4,5,6,7, y 8 lados ###########
##############################################################

simulaciones <- lapply(3:8,simulacion)

#### Pegamos las 6 tablas anteriores en una sola
vertices <- do.call(rbind,simulaciones)

#### Preparamos los datos para graficar los seis pol�gonos en un
#### lienzo de dos renglones


vertices$renglon <- 1
vertices$renglon[45004:90006] <- 2

##########################################
###########      Graficamos    ###########
##########################################

#### Comentarios.
#### 1) Utilizamos la columna renglon para
####    dividir las gr�ficas en dos renglones (facet_wrap)

ggplot(vertices) +
  geom_point(aes(x=X,y=Y,color=nver)) +
  facet_wrap(renglon~nver)
