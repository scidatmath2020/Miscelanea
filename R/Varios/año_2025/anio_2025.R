# Cargar librerías
library(tidyverse)
library(gganimate)
library(png)  # Necesario para leer imágenes PNG

# Cargar la imagen de fondo
img <- readPNG("C:\\Users\\Usuario\\Documents\\scidata\\miscelanea\\R\\anio_nuevo_2025\\fondo.png")

# Parámetros de la explosión
#set.seed(42)
n_particles <- 50  # Número de partículas por círculo
n_frames <- 30     # Número de frames
n_circles <- 30     # Número de círculos

# Definir los centros, radios y colores de los círculos
centers <- data.frame(
  center_x = runif(n_circles, -5, 5),
  center_y = runif(n_circles, -5, 5),
  color = sample(c("red", "blue", "green", "yellow", "purple"), n_circles, replace = TRUE),
  circle = 1:n_circles,  # Agregar la columna 'circle'
  delay = sample(0:(n_frames - 1), n_circles, replace = TRUE) # Desfase de tiempo
)

# Generar datos para los cometas
fireworks <- expand.grid(
  id = 1:n_particles,
  frame = 1:(n_frames + max(centers$delay)), # Extender los frames según el máximo desfase
  circle = 1:n_circles
) %>%
  left_join(centers, by = "circle") %>%
  group_by(id, circle) %>%
  mutate(
    angle = runif(1, 0, 2 * pi),                      # Ángulo fijo por partícula
    adjusted_frame = frame - delay,                  # Ajustar el frame por el desfase
    r = ifelse(adjusted_frame > 0 & adjusted_frame <= n_frames,
               seq(0, 5, length.out = n_frames)[pmax(adjusted_frame, 1)], 0),
    x = center_x + r * cos(angle),                   # Coordenada x
    y = center_y + r * sin(angle),                   # Coordenada y
    alpha = ifelse(adjusted_frame > 0 & adjusted_frame <= n_frames,
                   1 - adjusted_frame / n_frames, 0) # Transparencia
  ) %>%
  ungroup()

# Crear la animación
plot <- ggplot(fireworks) +
  # Imagen de fondo
  annotation_raster(img, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  # Punto para la cabeza del cometa
  geom_point(aes(x = x, y = y, group = id, alpha = alpha, color = color),
             size = 3) +  # Color fijo para todas las partículas
  # Línea del centro a cada punto
  geom_segment(aes(x = center_x, y = center_y, xend = x, yend = y, alpha = alpha, color = color),
               size = 0.5) +  # Línea desde el centro
  theme_void() +  # Quitar todos los elementos de fondo
  theme(
    plot.background = element_rect(fill = "black", color = "black"),  # Fondo negro
    panel.background = element_rect(fill = "black", color = "black"),  # Fondo negro del panel
    plot.title = element_blank(),  # Eliminar título
    plot.subtitle = element_blank(),  # Eliminar subtítulo
    legend.position = "none"  # Eliminar leyenda
  ) +
  labs(title = "Explosión con múltiples círculos", subtitle = "Frame: {frame}") +
  transition_time(frame) +  # Transición por frame
  ease_aes('linear')        # Movimiento lineal

# Animar y guardar
animate(plot, duration = 5, fps = 20, width = 600, height = 600, renderer = gifski_renderer())
