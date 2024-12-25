library(ggplot2)
library(grid)
library(png)
library(gganimate)

fondo <- rasterGrob(readPNG("C:\\Users\\Usuario\\Documents\\scidata\\miscelanea\\R\\arbol_navidad\\fondo.png"), 
                    width = unit(1, "npc"), 
                    height = unit(1, "npc"))


generador_arbol = function(x){
  
  generar_hojas_esferas <- function(n, nivel) {
    mi_lista <- data.frame(
      tipo = rep("hoja", n),
      x = seq(-n/2, n/2, length.out = n),
      y = rep(nivel, n),
      color = rep("darkgreen", n)  # Color inicial verde para hojas
    )
    
    if (n > 3) {
      lugar_esferas <- sample(1:n, size = floor(n / 3))
      mi_lista$tipo[lugar_esferas] <- "esfera"
      mi_lista$color[lugar_esferas] <- "red"  # Cambiar color a rojo para esferas
    }
    return(mi_lista)
  }
  
  pel <- 30  
  base <- 10  
  
  arbol_df <- data.frame(tipo = character(), x = numeric(), y = numeric(), color = character())
  
  for (i in 1:pel) {
    arbol_df <- rbind(arbol_df, generar_hojas_esferas(i, pel - i + 1))
  }
  
  for (i in 1:base) {
    tronco <- data.frame(
      tipo = "tronco",
      x = 0,
      y = -i,
      color = "brown"  
    )
    arbol_df <- rbind(arbol_df, tronco)
  }
  
  arbol_df$shape <- ifelse(arbol_df$tipo == "esfera", 19, 25)
  
  arbol_df[1,2]=0
  arbol_df[arbol_df$y<0,]$y = arbol_df[arbol_df$y<0,]$y + 1 
  
  
  complemento = data.frame(tipo="tronco",x=1,y=c(0:-9),color="brown",shape=25)
  
  arbol_df = rbind(arbol_df,complemento)
  
  arbol_df[arbol_df$y<=0,]$x = arbol_df[arbol_df$y<=0,]$x - 0.5
  arbol_df$tiempo = x
  return(arbol_df)
}

arboles = lapply(1:5,generador_arbol)
arboles = do.call(rbind,arboles)


animacion = ggplot(arboles, 
                   aes(x = x, y = y, shape = factor(shape), fill = color)) +
  annotation_custom(fondo, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_point(size = 5, color = "black") +
  scale_fill_identity() +  
  scale_shape_manual(values = c("19" = 21, "25" = 25)) +
  coord_equal() +
  theme_void() +
  theme(plot.background = element_blank(),
        legend.position = "none") +
  transition_time(tiempo)

animacion_final <- animate(animacion,duration=4) 
animacion_final

