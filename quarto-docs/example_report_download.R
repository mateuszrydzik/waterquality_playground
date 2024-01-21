
``` {r}
imagery_2023 <- get_sentinel2_imagery(
    aoi_32617,
    start_date = "2023-07-01",
    end_date = "2023-07-30",
    output_filename = "data/costarica_2023.tif"
)
```

``` {r}
imagery_2017 <- get_sentinel2_imagery(
    aoi_32617,
    start_date = "2017-06-01",
    end_date = "2017-07-30",
    output_filename = "data/costarica_2017.tif"
)
```
