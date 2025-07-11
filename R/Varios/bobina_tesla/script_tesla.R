library(tidyverse)
library(gganimate)
library(gifski)

n_rays     <- 90    # rayos por fotograma
n_frames   <- 40    # fotogramas totales
fps_anim   <- 15    # cuadros por segundo
radio_ext  <- 2.7   # radio de la esfera externa (contorno)
radio_int  <- 0.18  # radio visual del círculo central

genera_rayo <- function(id_rayo) {
  angle    <- runif(1, 0, 2 * pi)
  len      <- runif(1, 1.5, 2.4)
  n_points <- sample(6:10, 1)
  t        <- seq(0, 1, length.out = n_points)
  
  data.frame(
    x     = cos(angle) * len * t + rnorm(n_points, sd = 0.05),
    y     = sin(angle) * len * t + rnorm(n_points, sd = 0.05),
    group = id_rayo
  )
}

set.seed(123)  # reproducibilidad
rayos_todos <- lapply(
  1:n_frames,
  function(frame) {
    bind_rows(lapply(1:n_rays, genera_rayo)) |>
      mutate(frame = frame)
  }
) |> bind_rows()

n_central <- 3000  # puntos que forman el degradado
circle_df <- data.frame(
  x = runif(n_central, -radio_int,  radio_int),
  y = runif(n_central, -radio_int,  radio_int)
) |>
  mutate(
    r     = sqrt(x^2 + y^2),
    alpha = ifelse(r <= radio_int, 1 - r / radio_int, 0),
    col   = rgb(
      1 - 0.4 * (r / radio_int),   # R canal
      1 - 0.4 * (r / radio_int),   # G canal
      1 - 0.4 * (r / radio_int),   # B canal
      alpha                        # transparencia
    )
  ) |>
  filter(alpha > 0)


p <- ggplot() +
  geom_path(
    data  = rayos_todos,
    aes(x = x, y = y, group = interaction(frame, group)),
    colour    = "deepskyblue",
    linewidth = 1,
    alpha     = 0.8
  ) +
  ggplot2::annotate(
    "path",
    x = radio_ext * cos(seq(0, 2 * pi, length.out = 200)),
    y = radio_ext * sin(seq(0, 2 * pi, length.out = 200)),
    colour  = "gray70",
    linewidth = 1
  ) +
  geom_point(
    data = circle_df,
    aes(x = x, y = y, colour = col),
    size = 0.9,
    shape = 16,
    show.legend = FALSE
  ) +
  scale_colour_identity() +
  coord_fixed() +
  theme_void() +
  theme(
    plot.background  = element_rect(fill = "black", colour = NA),
    panel.background = element_rect(fill = "black", colour = NA)
  ) +
  transition_states(frame, transition_length = 1, state_length = 0) +
  ease_aes("linear")

animate(
  p,
  nframes  = n_frames,
  fps      = fps_anim,
  width    = 600,
  height   = 600,
#  renderer = gifski_renderer("tesla_coil_esfera.gif")
)

