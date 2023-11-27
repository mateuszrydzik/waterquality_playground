library(rsi)
library(sf)
library(terra)
library(tmap)

#pobranie wskaźników
asi <- spectral_indices()
View(asi)

# stworzenie poligonu dla WNGIG
wngig <- st_point(c(16.94188559453277, 52.46409983422002))
wngig <- st_set_crs(st_sfc(wngig), 4326)
wngig <- st_buffer(st_transform(wngig, 2180), 500)

# sentinel 2
# pobieranie obrazów

wngig_sentinel2_image <- get_sentinel2_imagery(
    wngig,
    start_date = "2023-10-01",
    end_date = "2023-10-31",
    output_filename = "data/wngig_sentinel2_image.tif"
)

# wczytanie obrazów
wngig_sentinel2_rast <- terra::rast(wngig_sentinel2_image)

# wizualizacja

# podgląd rastra na tle OSM
tmap_mode("view")
tm_shape(wngig_sentinel2_rast[[4]]) +
    tm_raster()

terra::plot(wngig_sentinel2_rast[[4]])

# landsat
# pobieranie obrazów
wngig_landsat_image <- get_landsat_imagery(
    wngig,
    start_date = "2023-09-01",
    end_date = "2023-10-31",
    output_filename = "data/wngig_landsat_image.tif"
)

# wczytanie obrazów
wngig_landsat_rast <- terra::rast(wngig_landsat_image)

# porównanie obrazów rgb
par(mfrow = c(1, 2))
terra::plotRGB(wngig_sentinel2_rast, r = 4, g = 3, b = 2, stretch = "lin")
terra::plotRGB(wngig_landsat_rast, r = 4, g = 3, b = 2, stretch = "lin")

# obliczenie wskaźnika ndvi
ndvi <- asi[asi$short_name == "NDVI", ]

ndvi_landsat <- calculate_indices(
    wngig_landsat_rast,
    ndvi,
    output_filename = tempfile(fileext = ".tif")
)

ndvi_sentinel2 <- calculate_indices(
    wngig_sentinel2_rast,
    ndvi,
    output_filename = tempfile(fileext = ".tif")
)


terra::plot(terra::rast(ndvi_sentinel2))
terra::plot(terra::rast(ndvi_landsat))


#pobranie dem dla obszaru badan

wngig_dem <- get_dem(wngig)
terra::plot(terra::rast(wngig_dem))


# kolejny przykład, dla Białej Góry i zbiornika wodnego
bg <- st_point(c(14.473790, 53.948800))
bg <- st_set_crs(st_sfc(bg), 4326)
bg <- st_buffer(st_transform(bg, 2180), 100)

# korzystamy z obrazu sentinel2
bg_sentinel2_image <- get_sentinel2_imagery(
    bg,
    start_date = "2023-07-28",
    end_date = "2023-07-31",
    output_filename = tempfile(fileext = ".tif")
)

bg_sentinel2_rast <- terra::rast(bg_sentinel2_image)

# podgląd rastra na tle osm
tm_shape(bg_sentinel2_rast[[1]]) +
    tm_raster()

par(mfrow = c(1, 1))
terra::plotRGB(bg_sentinel2_rast, r = 4, g = 3, b = 2, stretch = "lin")

# obliczenie wskaźników wodnych dla Sentinel-2
View(asi[asi$application_domain == "water", ])
water_indices <- asi[asi$application_domain == "water", ]
water_sentinel2_indices <- water_indices["Sentinel-2" %in% water_indices$platforms, ]
water_sentinel2_indices <- water_sentinel2_indices[water_sentinel2_indices$short_name !="NDWIns", ]
water_sentinel2_indices <- water_sentinel2_indices[water_sentinel2_indices$short_name !="MBWI", ]


water_sentinel2 <- calculate_indices(
    bg_sentinel2_rast,
    water_sentinel2_indices,
    output_file = tempfile(fileext = ".tif")
)

terra::plot(terra::rast(water_sentinel2))
