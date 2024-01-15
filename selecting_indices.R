library(rsi)
library(terra)
library(sf)
library(tmap)
library(waterquality)

calculate_index <- function(raster, index_name, use_wq = FALSE, sat = "landsat8") {
  if (use_wq) {
    index_calculation <- wq_calc(
      raster_mask,
      alg = index_name,
      sat = sat
    )
    index_calculation
  } else {
    index_calculation <- calculate_indices(
      raster_mask,
      asi[asi$short_name %in% c(index_name), ],
      output_filename = tempfile(fileext = ".tif")
    )
    terra::rast(index_calculation)
  }
}

asi <- spectral_indices()
aoi <- st_read("data/costa_rica.gpkg")
aoi_32617 <- st_transform(aoi, 32617)
aoi_buffer <- st_buffer(aoi_32617, 500)
terminal <- aoi_32617[1, ]

terminal_sentinel2_imagery <- get_sentinel2_imagery(
    terminal,
    start_date = "2023-06-01",
    end_date = "2023-7-31",
    output_filename = tempfile(fileext = ".tif")
)

terminal_rast <- terra::rast(terminal_sentinel2_imagery)
raster_crop <- terra::crop(terminal_rast, terra::ext(terminal))
raster_mask <- terra::mask(raster_crop, terminal)
terra::plotRGB(raster_mask, r = 4, g = 3, b = 2, stretch = "lin")


ndci <- calculate_index(raster_mask, "NDCI", sat="sentinel2")
ndti <- calculate_index(raster_mask, "NDTI", sat="sentinel2")
sabi <- calculate_index(raster_mask, "Al10SABI", use_wq = TRUE, sat = "sentinel2")
turb <- calculate_index(raster_mask, "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")