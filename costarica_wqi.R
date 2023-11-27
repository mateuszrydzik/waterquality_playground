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

aoi

costarica_2014 <- terra::rast("data/costarica_2014.tif")
names(costarica_2014) <- c("A", "B", "G", "R", "N", "S1", "S2")
terra::plotRGB(costarica_2014, r = "R", g = "G", b = "B", stretch = "lin")

costarica_2019 <- terra::rast("data/costarica_2019_ab.tif")
names(costarica_2019) <- c("A", "B", "G", "R", "RE1", "RE2", "RE3", "N", "N2", "S1", "S2")


calculate_index <- function(raster, aoi, index_name, use_wq = FALSE, sat = "landsat8") {
  raster_crop <- terra::crop(raster, terra::ext(aoi))
  raster_mask <- terra::mask(raster_crop, aoi)

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

costarica_2014_1_ndti <- calculate_index(costarica_2014, aoi_32617[1, 0], "NDTI")
costarica_2014_2_ndti <- calculate_index(costarica_2014, aoi_32617[2, 0], "NDTI")

costarica_2019_1_ndti <- calculate_index(costarica_2019, aoi_32617[1, 0], "NDTI")
costarica_2019_2_ndti <- calculate_index(costarica_2019, aoi_32617[2, 0], "NDTI")

par(mfrow = c(2, 2))
terra::plot(costarica_2014_1_ndti)
terra::plot(costarica_2014_2_ndti)
terra::plot(costarica_2019_1_ndti)
terra::plot(costarica_2019_2_ndti)

costarica_2014_1_turbidity <- calculate_index(costarica_2014, aoi_32617[1, 0], "TurbBe16GreenPlusRedBothOverViolet", use_wq = TRUE, sat = "landsat8")
costarica_2014_2_turbidity <- calculate_index(costarica_2014, aoi_32617[2, 0], "TurbBe16GreenPlusRedBothOverViolet", use_wq = TRUE, sat = "landsat8")

costarica_2019_1_turbidity <- calculate_index(costarica_2019, aoi_32617[1, 0], "TurbBe16GreenPlusRedBothOverViolet", use_wq = TRUE, sat = "sentinel2")
costarica_2019_2_turbidity <- calculate_index(costarica_2019, aoi_32617[2, 0], "TurbBe16GreenPlusRedBothOverViolet", use_wq = TRUE, sat = "sentinel2")

par(mfrow = c(2, 2))
terra::plot(costarica_2014_1_turbidity)
terra::plot(costarica_2014_2_turbidity)
terra::plot(costarica_2019_1_turbidity)
terra::plot(costarica_2019_2_turbidity)

costarica_2014_1_chlorophyll <- calculate_index(costarica_2014, aoi_32617[1, 0], "Al10SABI", use_wq = TRUE, sat = "landsat8")
costarica_2014_2_chlorophyll <- calculate_index(costarica_2014, aoi_32617[2, 0], "Al10SABI", use_wq = TRUE, sat = "landsat8")

costarica_2019_1_chlorophyll <- calculate_index(costarica_2019, aoi_32617[1, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
costarica_2019_2_chlorophyll <- calculate_index(costarica_2019, aoi_32617[2, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")

par(mfrow = c(2, 2))
terra::plot(costarica_2014_1_chlorophyll)
terra::plot(costarica_2014_2_chlorophyll)
terra::plot(costarica_2019_1_chlorophyll)
terra::plot(costarica_2019_2_chlorophyll)

par(mfrow = c(1, 1))
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

terminal_chlorophyll <- calculate_index(terminal_sentinel, aoi_32617[1, ], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
terra::plot(terminal_chlorophyll)

View(asi[asi$application_domain == "water", ])
water_indices <- asi[asi$application_domain == "water", ]
water_sentinel2_indices <- water_indices[water_indices$short_name == "ANDWI", ]

terminal_andwi <- calculate_index(terminal_sentinel, aoi_32617[1, ], "ANDWI", use_wq = FALSE)
terra::plot(terminal_andwi)

costarica_2014_1_andwi <- calculate_index(costarica_2014, aoi_32617[1, ], "ANDWI", use_wq = FALSE)
costarica_2014_2_andwi <- calculate_index(costarica_2014, aoi_32617[2, ], "ANDWI", use_wq = FALSE)

costarica_2019_1_andwi <- calculate_index(costarica_2019, aoi_32617[1, ], "ANDWI", use_wq = FALSE)
costarica_2019_2_andwi <- calculate_index(costarica_2019, aoi_32617[2, ], "ANDWI", use_wq = FALSE)

par(mfrow = c(2, 2))
terra::plot(costarica_2014_1_andwi)
terra::plot(costarica_2014_2_andwi)
terra::plot(costarica_2019_1_andwi)
terra::plot(costarica_2019_2_andwi)
