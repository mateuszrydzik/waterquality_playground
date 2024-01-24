
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
``` {r}
ndci_2023_lr <- calculate_index(rast_2023, aoi_32617[1, 0], "NDCI", sat="sentinel2")
#ndti_2023_lr <- calculate_index(rast_2023, aoi_32617[1, 0], "NDTI", sat="sentinel2")
sabi_2023_lr <- calculate_index(rast_2023, aoi_32617[1, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
#turb_2023_lr <- calculate_index(rast_2023, aoi_32617[1, 0], "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")

ndci_2017_lr <- calculate_index(rast_2017, aoi_32617[1, 0], "NDCI", sat="sentinel2")
#ndti_2017_lr <- calculate_index(rast_2017, aoi_32617[1, 0], "NDTI", sat="sentinel2")
sabi_2017_lr <- calculate_index(rast_2017, aoi_32617[1, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
#turb_2017_lr <- calculate_index(rast_2017, aoi_32617[1, 0], "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")

ndci_2023_north <- calculate_index(rast_2023, aoi_32617[5, 0], "NDCI", sat="sentinel2")
#ndti_2023_north <- calculate_index(rast_2023, aoi_32617[5, 0], "NDTI", sat="sentinel2")
sabi_2023_north <- calculate_index(rast_2023, aoi_32617[5, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
#turb_2023_north <- calculate_index(rast_2023, aoi_32617[5, 0], "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")

ndci_2017_north <- calculate_index(rast_2017, aoi_32617[5, 0], "NDCI", sat="sentinel2")
#ndti_2017_north <- calculate_index(rast_2017, aoi_32617[5, 0], "NDTI", sat="sentinel2")
sabi_2017_north <- calculate_index(rast_2017, aoi_32617[5, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
#turb_2017_north <- calculate_index(rast_2017, aoi_32617[5, 0], "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")

ndci_2023_south <- calculate_index(rast_2023, aoi_32617[2, 0], "NDCI", sat="sentinel2")
#ndti_2023_south <- calculate_index(rast_2023, aoi_32617[2, 0], "NDTI", sat="sentinel2")
sabi_2023_south <- calculate_index(rast_2023, aoi_32617[2, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
#turb_2023_south <- calculate_index(rast_2023, aoi_32617[2, 0], "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")

ndci_2017_south <- calculate_index(rast_2017, aoi_32617[2, 0], "NDCI", sat="sentinel2")
#ndti_2017_south <- calculate_index(rast_2017, aoi_32617[2, 0], "NDTI", sat="sentinel2")
sabi_2017_south <- calculate_index(rast_2017, aoi_32617[2, 0], "Al10SABI", use_wq = TRUE, sat = "sentinel2")
#turb_2017_south <- calculate_index(rast_2017, aoi_32617[2, 0], "TurbFrohn09GreenPlusRedBothOverBlue", use_wq = TRUE, sat = "sentinel2")

```