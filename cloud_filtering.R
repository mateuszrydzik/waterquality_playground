library(rsi)
library(sf)
library(rstac)
library(terra)
swarzedz <- st_point(c(17.108174, 52.405725))
swarzedz <- st_set_crs(st_sfc(swarzedz), 4326)
swarzedz <- st_buffer(st_transform(swarzedz, 2180), 5000)

swarzedz_qf <- function(bbox, stac_source, start_date, end_date, limit, ...) {
    geom <- rstac::cql2_bbox_as_geojson(bbox)
    datetime <- rstac::cql2_interval(start_date, end_date)

    request <- rstac::ext_filter(
        rstac::stac(stac_source),
        collection == "sentinel-2-l2a" &&
        t_intersects(datetime, {{datetime}}) &&
        s_intersects(geom, {{geom}}) &&
        platform == "Sentinel-2B" &&
        `eo:cloud_cover` < 25
    )
    rstac::items_fetch(rstac::post_request(request))
}

swarzedz_sentinel2_sep <- get_sentinel2_imagery(
    swarzedz,
    start_date = "2023-07-01",
    end_date = "2023-09-30",
    output_filename = tempfile(fileext = ".tif"),
    composite_function = NULL,
    query_function = swarzedz_qf
)

swarzedz_sentinel2_sep



swarzedz_sentinel2_07_14 <- terra::rast(swarzedz_sentinel2_sep[4])
swarzedz_sentinel2_09_12 <- terra::rast(swarzedz_sentinel2_sep[1])


ndvi <- asi[asi$short_name == "NDVI", ]

swarzedz_sentinel2_07_14_ndvi <- calculate_indices(
    swarzedz_sentinel2_07_14,
    ndvi,
    output_filename = tempfile(fileext = ".tif")
)

swarzedz_sentinel2_09_12_ndvi <- calculate_indices(
    swarzedz_sentinel2_09_12,
    ndvi,
    output_filename = tempfile(fileext = ".tif")
)

swarzedz_sentinel2_07_14_ndvi

par(mfrow = c(1, 2))
swarzedz_sentinel2_07_14_ndvi_rast <- terra::rast(swarzedz_sentinel2_07_14_ndvi)
swarzedz_sentinel2_09_12_ndvi_rast <- terra::rast(swarzedz_sentinel2_09_12_ndvi)
terra::plot(swarzedz_sentinel2_07_14_ndvi_rast, range = c(-1, 1))
terra::plot(swarzedz_sentinel2_09_12_ndvi_rast, range = c(-1, 1))