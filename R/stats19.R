main.file <- "casualties_active_london.Rds"
github <- "https://github.com/saferactive/saferactiveshiny/releases/download/0.0.2"

if(!file.exists(main.file)) {
  download.file(
    file.path(github, main.file),
    destfile = main.file)
}

casualties = readRDS(main.file)
# change this as desired but fed in from saferactive project
# input by colleagues
casualties = casualties[,grep("accident_|lat|long|
vehicles|casualties|date|day_|sex_of_casualty|age_of_casualty|
age_band_of_casualt|sex|vehicle_type|casualty_type|road_type|
time|local_|road_cl|limit|urban|junction_det|
class|pedestrian_crossing$|force", names(casualties))]

# sf::write_sf(casualties, "casualties.geojson")
# sf::write_sf(casualties, "casualties.csv")

########## sample of 50k
n = sample(nrow(casualties), 50e3)
cas_n = casualties[n,]

########## DT
library(data.table)
library(sf)
dt <- as.data.table(cas_n)
# leaves geometry as "sfc_POINT" "sfc"
coordinates <- st_coordinates(dt$geometry)
dt$lon <- coordinates[,1]
dt$lat <- coordinates[,2]
fwrite(dt, "casualties.csv") # 12mb
# sf::write_sf(cas_n, "casualties.geojson") 39mb
