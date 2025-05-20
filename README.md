# Animación de Modelo GLM Binomial en 3D

Este repositorio contiene un script en R que genera una animación 3D usando `plotly` a partir de un modelo binomial ajustado.

## 📂 Estructura

- `glm binomial 3D (plot-ly).R`: script R que genera una secuencia de imágenes y produce un GIF animado.
- `animacion.gif`: resultado final de la animación.
- `frames/`: carpeta opcional con imágenes `.png` intermedias, si se incluyen.

## ▶️ Ejecutar

Para generar la animación:

1. Asegurate de tener instalados los paquetes `plotly`, `animation`, `magick` y otros requeridos.
2. Abrí el script:

   [`glm binomial 3D (plot-ly).R`](glm%20binomial%203D%20(plot-ly).R)

3. Ejecutalo desde RStudio o una consola de R.
4. Se generará un archivo `.gif` con la animación final.

## 📊 Vista previa

![Animación generada](animacion_plotly.gif)

## 💡 Fragmento del código

```r
for (i in 1:20) {
  filename <- sprintf("x0_%02d.png", i)
  # Código para crear y guardar la imagen
}
