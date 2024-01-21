library(rsi)
library(terra)
library(sf)
library(tmap)
library(waterquality)
### get_landsat_imagery returns raster that mask out water bodies
### need to find if this is caused by rsi, rstac or planetary computer

asi <- spectral_indices()
aoi <- st_read("data/costa_rica.gpkg")
aoi_32617 <- st_transform(aoi, 32617)
aoi_buffer <- st_buffer(aoi_32617, 500)
terminal <- aoi_32617[1, ]

terminal_landsat_imagery <- get_landsat_imagery(
    terminal,
    start_date = "2023-08-01",
    end_date = "2023-08-31",
    output_filename = tempfile(fileext = ".tif")
)
term <- terra::rast(terminal_landsat_imagery)
terra::plotRGB(term, r = 4, g = 3, b = 2, stretch = "lin")


niechorze <- st_point(c(15.077849863423118, 54.09695525942903))
niechorze <- st_set_crs(st_sfc(niechorze), 4326)
niechorze <- st_buffer(st_transform(niechorze, 2180), 500)

niechorze_image <- get_landsat_imagery(
    poznan,
    start_date = "2023-06-01",
    end_date = "2023-08-30",
    output_filename = tempfile(fileext = ".tif")
)

poz_rast <- terra::rast(poz_landsat_image)
terra::plotRGB(poz_rast, r = 4, g = 3, b = 2, stretch = "lin")

# lets check rstac
library(rstac)
s_obj <- stac("https://planetarycomputer.microsoft.com/api/stac/v1")
get_request(s_obj)
 
aoi <- st_read("data/costa_rica.gpkg")
# aoi_32617 <- st_transform(aoi, 32617)
# aoi_buffer <- st_buffer(aoi_32617, 500)

it_obj <- s_obj |>
  stac_search(collections = "landsat-c2-l2",
              bbox = st_bbox(aoi),
              limit = 100) |> 
  get_request()


it_obj <- s_obj |> 
 stac_search(collections = "landsat-c2-l2",
  ext_filter(
    collection == "landsat-c2-l2"  &&
      `eo:cloud_cover` <= 30 && 
      anyinteracts(datetime, interval("2014-01-01", "2014-03-30"))
  ) |>
  post_request()

download_items <- it_obj |>
  assets_download(assets_name = "thumbnail", items_max = 10, overwrite = TRUE)


# TROP!!!!
``` {r}
landsat_mask_function <- function(raster) {
  raster == 23888
}
imagery <- get_landsat_imagery(
    aoi_32617,
    start_date = "2014-01-01",
    end_date = "2014-03-30",
    output_filename = tempfile(fileext = ".tif"),
    mask_function = NULL
)
```