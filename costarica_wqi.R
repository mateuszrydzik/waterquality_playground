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

costarica_2014_crop <- terra::crop(costarica_2014, terra::ext(aoi_32617[1, 0]))
costarica_2014_mask <- terra::mask(costarica_2014_crop, aoi_32617[1, 0])

costarica_2014_ndti_calculation <- calculate_indices(
    costarica_2014_mask,
    asi[asi$short_name %in% c("NDTI", "NDCI"), ],
    output_filename = tempfile(fileext = ".tif")
)

costarica_2014_ndti <- terra::rast(costarica_2014_ndti_calculation)

costarica_2014_turbidity <- wq_calc(
  costarica_2014_mask,
  alg = "TurbBe16GreenPlusRedBothOverViolet",
  sat = "landsat8"
)

View(wq_algorithms)

par(mfrow = c(2, 1))
terra::plot(costarica_2014_ndti)
terra::plot(costarica_2014_turbidity)

?Kn07KIVU
costarica_2014_turbidity <- wq_calc(
  costarica_2014_mask,
  alg = "TurbBe16GreenPlusRedBothOverViolet",
  sat = "sentinel2"
)

costarica_2014_chlorophyll <- wq_calc(
  costarica_2014_mask,
  alg = "Kn07KIVU",
  sat = "landsat8"
)

terra::plot(costarica_2014_chlorophyll)
