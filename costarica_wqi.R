library(rsi)
library(terra)
library(sf)
library(tmap)
library(waterquality)

asi <- spectral_indices()
aoi <- st_read("data/costa_rica.gpkg")
aoi_32617 <- st_transform(aoi, 32617)

tmap_mode("view")
tm_shape(aoi) +
    tm_polygons()

costarica_2014 <- terra::rast("data/costarica_2014.tif")
names(costarica_2014) <- c("A", "B", "G", "R", "N", "S1", "S2")
terra::plotRGB(costarica_2014, r = "R", g = "G", b = "B", stretch = "lin")

costarica_2019 <- terra::rast("data/costarica_2019.tif")
names(costarica_2019) <- c("A", "B", "G", "R", "RE1", "RE2", "RE3", "N", "N2")

costarica_2014_crop <- terra::crop(costarica_2014, terra::ext(aoi_32617[1, 0]))
costarica_2014_mask <- terra::mask(costarica_2014_crop, aoi_32617[1, 0])

costarica_2019_crop <- terra::crop(costarica_2019, terra::ext(aoi_32617[1, 0]))
costarica_2019_mask <- terra::mask(costarica_2019_crop, aoi_32617[1, 0])

costarica_2014_ndti_calculation <- calculate_indices(
    costarica_2014_mask,
    asi[asi$short_name %in% c("NDTI"), ],
    output_filename = tempfile(fileext = ".tif")
)

costarica_2014_ndti <- terra::rast(costarica_2014_ndti_calculation)

costarica_2014_turbidity <- wq_calc(
  costarica_2014_mask,
  alg = "TurbBe16GreenPlusRedBothOverViolet",
  sat = "landsat8"
)

costarica_2019_turbidity <- wq_calc(
  costarica_2019_mask,
  alg = "TurbBe16GreenPlusRedBothOverViolet",
  sat = "sentinel2"
)

par(mfrow = c(2, 1))
terra::plot(costarica_2014_ndti)
terra::plot(costarica_2014_turbidity)


terra::plot(costarica_2014_turbidity)
terra::plot(costarica_2019_turbidity)

costarica_2014_chlorophyll <- wq_calc(
  costarica_2014_mask,
  alg = "Al10SABI",
  sat = "landsat8"
)

costarica_2019_chlorophyll <- wq_calc(
  costarica_2019_mask,
  alg = "Al10SABI",
  sat = "sentinel2"
)

terra::plot(costarica_2014_chlorophyll)
terra::plot(costarica_2019_chlorophyll)



terminal <- st_point(c(-83.097999, 10.012890))
terminal <- st_set_crs(st_sfc(terminal), 4326)
terminal <- st_buffer(st_transform(terminal, 32617), 1000)
tmap_mode("view")
tm_shape(terminal) +
    tm_polygons()

terminal_sentinel2_image <- get_sentinel2_imagery(
    terminal,
    start_date = "2023-09-01",
    end_date = "2023-09-30",
    output_filename = tempfile(fileext = ".tif")
)

terminal_sentinel <- terra::rast(terminal_sentinel2_image)
terra::plotRGB(terminal_sentinel, r = 4, g = 3, b = 2, stretch = "lin")

terminal_sentinel

terminal_chlorophyll <- wq_calc(
  terminal_sentinel,
  alg = "Al10SABI",
  sat = "sentinel2"
)

tm_shape(terminal_chlorophyll) +
    tm_raster()

terra::plot(terminal_chlorophyll)

