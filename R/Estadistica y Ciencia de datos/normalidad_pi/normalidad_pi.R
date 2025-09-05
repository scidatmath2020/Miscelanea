# Por si no están instaladas las bibliotecas

#install.packages("tidyverse")
#install.packages("gganimate")
#install.packages("Rmpfr")
#install.packages("magick")

library(tidyverse)
library(gganimate)
library(Rmpfr)
library(magick)
library(patchwork)

N = 1000
precision_necesaria <- ceiling(N * 3.32) + 100

pi_digits <- formatMpfr(Const("pi", precision_necesaria), digits = N)
pi_digits_clean <- gsub("[^0-9]", "", pi_digits)
digitos <- strsplit(pi_digits_clean, "")[[1]]
length(digitos)

contador = function(n){
  auxiliar = table(factor(digitos[1:n],levels=c("0","1","2","3","4","5","6","7","8","9")))
  tabla = data.frame("dígito"=auxiliar,"tiempo"=n)
  names(tabla) = c("dígito","total","tiempo")
  return(tabla)
}

secuencia = seq(0,N,10)
L = do.call(rbind,lapply(secuencia,contador))
Freqs = L %>% group_by(tiempo) %>% mutate(frecuencia=total*100/tiempo)


texto_data <- Freqs %>%
  group_by(tiempo) %>%
  summarise(x_pos = 900,
            y_pos = 20) %>%
  distinct(tiempo, x_pos, y_pos)

pal <- scales::hue_pal()(10)
names(pal) <- as.character(0:9)

pie_df <- Freqs %>%
  filter(tiempo > 0) %>%
  transmute(tiempo,
            digito = as.character(`dígito`),
            prop   = total/tiempo)

tira_df <- pie_df %>%
  mutate(pos = as.integer(digito) + 1,
         pct_txt = paste0(round(prop*100), "%"))

# DEFINIR LOS GRÁFICOS
p_evolucion = ggplot() +
  geom_line(data = Freqs,
            mapping = aes(x = tiempo,
                          y = frecuencia,
                          color = dígito),
            linewidth = 1,
            show.legend = FALSE) +
  geom_hline(yintercept = 10, linetype = "dashed") +
  geom_text(data = texto_data,
            aes(x = x_pos, y = y_pos, 
                label = paste0("Total de dígitos:\n", tiempo)),
            size = 10,
            color = "black",
            hjust = 1,
            vjust = 1)  +
  scale_y_continuous(
    breaks = c(0, 5, 10, 15, 20, 25),
    labels = c("0%", "5%", "10%", "15%", "20%", "25%"),
    limits = c(0, 25)
  ) +
  scale_x_continuous(
    breaks = seq(0, N, 100),
    labels = seq(0, N, 100),
    limits = c(0, N)
  ) +
  labs(title = "Evolución de frecuencias de dígitos en π",
       x = "Número de dígitos analizados",
       y = "Frecuencia relativa (%)") +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "gray90", linewidth = 0.2),
    panel.grid.minor = element_line(color = "gray95", linewidth = 0.1),
    panel.border = element_blank(),
    axis.line = element_line(color = "gray70")
  ) +
  transition_reveal(tiempo) +
  ease_aes('linear')

# PASTEL SIMPLIFICADO con etiquetas 
p_pastel <- ggplot(pie_df, aes(x = 1.2, y = prop, fill = digito)) +
  geom_col(width = 1, color = "white", show.legend = FALSE) +
  geom_text(aes(x = 1.5, label = digito),
            position = position_stack(vjust = 0.5),
            color = "black",
            size = 5,
            fontface = "bold") +
  coord_polar(theta = "y") +
  xlim(0.5, 1.8) +
  scale_fill_manual(values = pal) +
  labs(title = "Visualizando \u03C0",
       subtitle = "{current_frame} dígitos considerados") +
  theme_void(base_size = 16) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", hjust = 0.5, size=24),
        plot.subtitle = element_text(hjust = 0.5),
        plot.margin   = margin(t = 10, r = 20, b = -10, l = 20)) +
  transition_manual(tiempo)

p_tira <- ggplot(tira_df, aes(x = pos, color = digito)) +
  geom_text(aes(y = 1, label = digito), size = 6, fontface = "bold") +
  geom_text(aes(y = 0.6, label = pct_txt), size = 6) +
  scale_color_manual(values = pal) +
  coord_cartesian(xlim = c(0.5, 10.5), ylim = c(0, 2), expand = FALSE) +
  theme_void() +
  theme(legend.position = "none",
        plot.margin = margin(t = -10, r = 20, b = 0, l = 20)) +
  transition_manual(tiempo)

# RENDERIZAR LAS TRES ANIMACIONES
nframes <- length(unique(pie_df$tiempo))

gif_evolucion <- animate(p_evolucion, nframes = nframes, fps = 10,
                         width = 800, height = 600, renderer = gifski_renderer())

gif_pastel <- animate(p_pastel, nframes = nframes, fps = 10,
                      width = 800, height = 420, renderer = gifski_renderer())

gif_tira <- animate(p_tira, nframes = nframes, fps = 10,
                    width = 800, height = 120, renderer = gifski_renderer())

# COMBINAR CON MAGICK
img_pastel <- image_read(gif_pastel)
img_tira <- image_read(gif_tira)
img_evolucion <- image_read(gif_evolucion)

m <- min(length(img_pastel), length(img_tira), length(img_evolucion))
img_pastel <- img_pastel[1:m]
img_tira <- img_tira[1:m]
img_evolucion <- img_evolucion[1:m]

combined_all <- lapply(1:m, function(i) {
  image_append(c(img_pastel[i], img_tira[i], img_evolucion[i]), stack = TRUE)
})

final_animation <- image_animate(image_join(combined_all), 
                                 fps = 10, 
                                 dispose = "previous")

# MOSTRAR Y GUARDAR
final_animation
image_write(final_animation, "pi_animation_pastel_tira_evolucion.gif", quality = 100)

