library(tidyverse)
library(gganimate)

t_vals <- seq(0, 24*pi, length.out = 1000)

reloj <- tibble(
  t = t_vals,
  x_minutero = 2*sin(t),
  y_minutero = 2*cos(t),
  x_horero = sin(t / 12),
  y_horero = cos(t / 12)
)

segmento <- reloj %>% mutate(id = row_number())

manecillas <- reloj %>%
  pivot_longer(cols = c(x_minutero, y_minutero, x_horero, y_horero),
               names_to = c(".value", "manecilla"),
               names_pattern = "(x|y)_(.*)")

circle <- tibble(
  angle = seq(0, 2 * pi, length.out = 200),
  x = 2.5 * cos(angle),
  y = 2.5 * sin(angle)
)

marcas_minutos <- tibble(
  angle = seq(0, 2 * pi, length.out = 61)[-61],
  x_start = 2.5 * cos(angle),
  y_start = 2.5 * sin(angle),
  x_end = 2.35 * cos(angle),
  y_end = 2.35 * sin(angle)
)

marcas_horas <- tibble(
  angle = seq(0, 2 * pi, length.out = 13)[-13],
  x_start = 2.5 * cos(angle),
  y_start = 2.5 * sin(angle),
  x_end = 2.1 * cos(angle),
  y_end = 2.1 * sin(angle)
)

p <- ggplot() +
  geom_path(data = circle, aes(x = x, y = y), color = "#E6E6E6", size = 1) +
  geom_segment(data = marcas_minutos,
               aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "#E6E6E6", size = 0.3) +
  geom_segment(data = marcas_horas,
               aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "#E6E6E6", size = 0.7) +
  geom_segment(
    data = segmento,
    aes(x = x_minutero, y = y_minutero, xend = x_horero, yend = y_horero, group = id),
    color = "#E36B2E80", size = 0.5
  ) +
  geom_segment(
    data = manecillas,
    aes(x = 0, y = 0, xend = x, yend = y),
    color = "#E6E6E6", size = 1.2
  ) +
  coord_fixed(xlim = c(-2.6, 2.6), ylim = c(-2.6, 2.6)) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#1D1545", color = NA),
    legend.position = "none"
  ) +
  transition_time(t) +
  shadow_mark(past = TRUE, future = FALSE, alpha = 0.3, exclude_layer = c(1,2,3,5))

animate(p, fps = 20, duration = 20, width = 620, height = 620)
