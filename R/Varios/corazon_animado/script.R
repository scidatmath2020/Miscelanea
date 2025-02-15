library(tidyverse)
library(gganimate)

# Función de transformación de rotación
rotate <- function(x, y, theta) {
  x_new <- x * cos(theta) - y * sin(theta)
  y_new <- x * sin(theta) + y * cos(theta)
  data.frame(x = x_new, y = y_new)
}

# Función constructor
constructor <- function(x) {
  return(x - 2 - 2 * floor((x - 1) / 2))
}


t_c <- seq(0, 2 * pi, 0.01)

corazon = data.frame(x=16*sin(t_c)^3,
                     y=13*cos(t_c)-5*cos(2*t_c)-2*cos(3*t_c)-cos(4*t_c),
                     tipo = "c")

# Crear la flor base
t_f <- seq(0, 12 * pi, 0.01)  # Antes: 0.01, ahora: 0.05
flor_base <- data.frame(
  x = 3 * cos(t_f) * (abs(6 * constructor(9 * t_f / (4 * pi))) - 4.5),
  y = 3 * sin(t_f) * (abs(6 * constructor(9 * t_f / (4 * pi))) - 4.5)
)

# Reducimos el número de frames
frames <- seq(0, 2 * pi, length.out = 100)  # Antes: 100, ahora: 30

# Crear los datos animados con líneas al centro
flor_anim <- bind_rows(lapply(frames, function(theta) {
  flor_rotada <- rotate(flor_base$x, flor_base$y, theta)
  flor_rotada$frame <- theta
  flor_rotada$x0 <- 0
  flor_rotada$y0 <- 0
  return(flor_rotada)
}))

# Graficar la versión rápida
p <- ggplot() +
  geom_segment(data=flor_anim,aes(x = x0, y = y0, xend = x, yend = y, group = interaction(frame, x)), 
               color = "blue", alpha = 0.5) +
  geom_segment(data=corazon,aes(x = 0, y = 0, xend = x, yend = y), 
               color = "blue", alpha = 0.5) +
  geom_point(data=corazon,mapping = aes(x = x, y = y), color="red",size = 0.7) +
  geom_path(data=flor_anim,aes(x, y, group = frame), color = "green") +
  annotate("text", x = 0, y = -8, label = "SciData les desea\nun amoroso 14 de febrero", 
           color = "white", size = 6, fontface = "bold", family = "serif") +
  theme(
    panel.background = element_rect(fill = "#202020"),
    panel.grid = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  ) +
  transition_time(frame) +
  ease_aes('linear')

animate(p, fps = 20, duration = 5, width = 600, height = 600)  