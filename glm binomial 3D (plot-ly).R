setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

reticulate::use_python("/usr/bin/python3")

library(plotly)
library(animation)
# Simular datos
set.seed(123)
n <- 10
x <- runif(100, 0, 20)
p <- 1 / (1 + exp(-(-3 + 0.3 * x)))
y <- rbinom(100, size = n, prob = p)
datos <- data.frame(x, y)

# Ajustar modelo binomial
modelo <- glm(cbind(y, n - y) ~ x, family = binomial, data = datos)

# Curva de predicción
x_pred <- seq(0, 20, length.out = 100)
p_pred <- predict(modelo, newdata = data.frame(x = x_pred), type = "response")

# Valor puntual
for(x0 in seq(0, 20, by=1)){
p0 <- predict(modelo, newdata = data.frame(x = x0), type = "response")
ys <- 0:n
probs <- dbinom(ys, size = n, prob = p0)

# Armar data frame para las barras
barras <- data.frame(
  x = rep(x0, length(ys)),
  y = ys,
  z0 = 0,
  z1 = probs,
  color = "lightblue"
)

# Inicializar figura con puntos, línea y punto esperado
fig <- plot_ly() %>%
  add_markers(data = datos, x = ~x, y = ~y, z = 0,
              marker = list(color = "black", size = 4),
              name = "Observaciones") %>%
  add_trace(x = x_pred, y = n * p_pred, z = 0,
            type = 'scatter3d', mode = 'lines',
            line = list(color = 'red', width = 5),
            name = "Curva esperada") %>%
  add_markers(x = x0, y = n * p0, z = 0,
              marker = list(color = "blue", size = 5),
              name = "Esperado") %>%
  add_trace(x = rep(x0, 11), y = 0:10, z = 0,
            type = 'scatter3d', mode = 'lines',
            line = list(color = 'blue', width = 6, dash = "dash"))

# Agregar barras verticales una por una
for (i in seq_len(nrow(barras))) {
  fig <- fig %>% add_trace(
    type = "scatter3d",
    mode = "lines",
    x = c(barras$x[i], barras$x[i]),
    y = c(barras$y[i], barras$y[i]),
    z = c(barras$z0[i], barras$z1[i]),
    line = list(color = barras$color[i], width = 30),
    showlegend = FALSE
  )
}

# Agregar layout con orientación de cámara
fig <- fig %>% layout(
  scene = list(
    xaxis = list(
      title = "Tiempo de estudio",
      tickfont = list(size = 12),  # Tamaño de fuente de las etiquetas
      titlefont = list(size = 20)  # Tamaño del título del eje
    ),
    yaxis = list(
      title = "Respuestas correctas",
      tickfont = list(size = 12),
      titlefont = list(size = 20)
    ),
    zaxis = list(
      title = "Probabilidad",
      tickfont = list(size = 12),
      titlefont = list(size = 20),
      showgrid = T, range = c(0, 0.4)
    ),
    aspectratio = list(x = 2, y = 1.5, z = 0.5),  # Aquí se estira el eje X
    camera = list(eye = list(x = 2, y = -2.5, z = 1.2)) 
  ),
  showlegend = FALSE
)

# fig

filename=sprintf("frames/plotly_x0_%02d.png", x0)
print(x0)
save_image(fig, filename)
}

library(ggiraph)

# Nombres de archivos
imgs= list.files(path="frames", pattern="*.png$", full.names = T)


# Secuencia: ida y vuelta
seq_imgs <- c(imgs, rev(imgs[-length(imgs)]))  # evito repetir la última

# Crear la animación y guardarla como GIF (opcional)
saveGIF({
  for (img in seq_imgs) {
    im <- magick::image_read(img)
    plot.new()
    rasterImage(im, 0, 0, 1, 1)
    ani.pause(0.2)  # pausa de 0.2 segundos
  }
}, movie.name = "animacion_plotly.gif", interval = 0.2, ani.width = 1600, ani.height = 1200)


