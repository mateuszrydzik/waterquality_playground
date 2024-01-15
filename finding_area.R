library(terra)
library(sf)
library(motif)
library(tmap)
library(stars)
aoi <- st_read("data/costa_rica.gpkg")
aoi_32617 <- st_transform(aoi, 32617)
terminal <- aoi_32617[1, ]
terminal_buffer <- st_buffer(terminal, 800)



tmap_mode("view")
tm_shape(terminal_buffer) +
    tm_polygons()

costarica <- read_stars("data/costaricacoast.tif")
costarica <- terra::rast("data/costaricacoast.tif")

landcover_ext <- st_crop(costarica, st_transform(terminal_buffer, 4326))

search_1 = lsp_search(landcover_ext, costarica, 
                      type = "cove", dist_fun = "jensen-shannon",
                      window = 100, threshold = 1)
search_1


my_breaks = c(0, 0.001, 0.01, 0.1, 1.01)
tm_shape(search_1) +
  tm_raster("dist", breaks = my_breaks, palette = "-viridis") +
  tm_layout(legend.outside = TRUE)
tm_shape(search_1) +
  tm_raster("dist", breaks = my_breaks, palette = "-viridis")
