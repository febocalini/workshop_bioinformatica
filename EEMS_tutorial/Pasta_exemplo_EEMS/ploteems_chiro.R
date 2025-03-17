### Plotting EEMS Brejos ###### Chiroxiphia


setwd("C:/Users/Fernanda Bocalini/Dropbox/pos-doc/EEMS_brejos/chiroxiphia")
sample.info <- read.table("pop_map_chiro.csv", sep = ",", header = TRUE)

install.packages(c("Rcpp","RcppEigen","raster","rgeos","sp"))

## Check that the current directory contains the rEEMSplots source directory (from GitHub)
if (file.exists("./rEEMSplots/")) {
  install.packages("rEEMSplots", repos=NULL, type="source")
} else {
  stop("Move to the directory that contains the rEEMSplots source to install the package.")
}



#--------------------------------------#
# Examine results using nDemes = 200 ####
#--------------------------------------#

library(rEEMSplots)
Sys.setenv(R_GSCMD="C:/Program Files/gs/gs9.53.1/bin/gswin64c.exe")
install.packages("rgdal")
install.packages("https://cran.r-project.org/src/contrib/Archive/rgdal/rgdal_1.6-7.tar.gz", repos = NULL, type = "source")

library(rgdal)
library(rworldmap)
install.packages("rworldxtra")

library(rworldxtra)
library(ggplot2)

## Read in and prepare sample coordinates
coords <- read.table("chiro_eems.coord", sep = "\t", header = FALSE)

projection_none <- "+proj=longlat +datum=WGS84"

projection_mercator <- "+proj=merc +datum=WGS84"

coords_merc <- spTransform(SpatialPoints(coords, CRS(projection_none)), CRS(projection_mercator))

coords_merc <- coords_merc@coords

## Set graphical elements, including maps and projection for plotting
map_world <- getMap()

map_americas <- map_world[which(map_world@data$continent == "South America"), ]

## Set paths to files
eems200_path <- setwd("C:/Users/Fernanda Bocalini/Dropbox/pos-doc/EEMS_brejos/chiroxiphia/d200/")

eems200_results <- file.path(eems200_path, c("output_run1","output_run2","output_run3"))

name200_figures <- file.path(eems200_path, "eems200")

## Plot
eems.plots(mcmcpath = eems200_results,
           plotpath = paste0(name200_figures, "-shapefile"),
           longlat = TRUE,
           projection.in = projection_none,
           projection.out = projection_mercator,
           m.plot.xy = { points(coords_merc, col = "black", pch = 21, cex  = 1.5) },
           q.plot.xy = { points(coords_merc, col = "black", pch = 21, cex  = 1.5) },
           add.map = TRUE,
           col.map = "black",
           lwd.map = 1,
           out.png = FALSE,
           plot.height = 9,
           plot.width = 9)


#--------------------------------------#
## Examine results using nDemes = 400 ####
#--------------------------------------#

## Read in and prepare sample coordinates
coords <- read.table("chiro_eems.coord", sep = "\t", header = FALSE)

projection_none <- "+proj=longlat +datum=WGS84"

projection_mercator <- "+proj=merc +datum=WGS84"

coords_merc <- spTransform(SpatialPoints(coords, CRS(projection_none)), CRS(projection_mercator))

coords_merc <- coords_merc@coords

## Set graphical elements, including maps and projection for plotting
map_world <- getMap()

map_americas <- map_world[which(map_world@data$continent == "South America"), ]

## Set paths to files
eems400_path <- setwd("C:/Users/Fernanda Bocalini/Dropbox/pos-doc/EEMS_brejos/chiroxiphia/d400/")

eems400_results <- file.path(eems400_path, c("output_run1","output_run2","output_run3"))

name400_figures <- file.path(eems400_path, "eems400")

## Plot
eems.plots(mcmcpath = eems400_results,
           plotpath = paste0(name400_figures, "-shapefile"),
           longlat = TRUE,
           projection.in = projection_none,
           projection.out = projection_mercator,
           m.plot.xy = { points(coords_merc, col = "black", pch = 21, cex  = 1.5) },
           q.plot.xy = { points(coords_merc, col = "black", pch = 21, cex  = 1.5) },
           add.map = TRUE,
           col.map = "black",
           lwd.map = 1,
           out.png = FALSE,
           plot.height = 9,
           plot.width = 9)


#--------------------------------------#
## Examine results using nDemes = 600 ####
#--------------------------------------#

## Read in and prepare sample coordinates

projection_none <- "+proj=longlat +datum=WGS84"

projection_mercator <- "+proj=merc +datum=WGS84"

coords_merc <- spTransform(SpatialPoints(coords, CRS(projection_none)), CRS(projection_mercator))

coords_merc <- coords_merc@coords

## Set graphical elements, including maps and projection for plotting
map_world <- getMap()

map_americas <- map_world[which(map_world@data$continent == "South America"), ]

## Set paths to files
eems600_path <- setwd("C:/Users/Fernanda Bocalini/Dropbox/pos-doc/EEMS_brejos/chiroxiphia/d600/")

eems600_results <- file.path(eems600_path, c("output_run1","output_run2","output_run3"))

name600_figures <- file.path(eems600_path, "eems600")

## Plot
eems.plots(mcmcpath = eems600_results,
           plotpath = paste0(name600_figures, "-shapefile"),
           longlat = TRUE,
           projection.in = projection_none,
           projection.out = projection_mercator,
           m.plot.xy = { points(coords_merc, col = "black", pch = 21, cex  = 1.5) },
           q.plot.xy = { points(coords_merc, col = "black", pch = 21, cex  = 1.5) },
           add.map = TRUE,
           col.map = "black",
           lwd.map = 1,
           out.png = FALSE,
           plot.height = 9,
           plot.width = 9)


#------------------------------#
## Final plots and regression ####
#------------------------------#

# Load results of the run using nDemes = 400
load("C:/Users/Fernanda Bocalini/Dropbox/pos-doc/EEMS_brejos/chiroxiphia/d400/eems400-shapefile-rdist.RData")

# Remove singleton demes for plotting
filtered_data <- G.component[G.component$size > 1, ]

# Plot geographic versus genetic distances
ggplot(data = filtered_data, aes(x = fitted, y = obsrvd)) + 
  geom_point(pch = 21, size = 5) +
  xlab("Great circle distance between demes (km)") +
  ylab("Genetic dissimilarity between demes") +
  scale_x_continuous(breaks = seq(0, 5000, by = 500)) +
  scale_y_continuous(labels = scales::label_number(accuracy = 0.01)) +
  theme_bw() +
  theme(axis.title = element_text(size = 15, color = "black"),
        axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# Test if there is a monotonic relationship between geographic and genetic distances
cor.test(filtered_data$fitted, filtered_data$obsrvd, method = "spearman")

# Fit a quadratic model and measure the strength of the fit
model.gen <- lm(obsrvd ~ poly(fitted, 2), data = filtered_data)

summary(model.gen)

# Plot geographic versus genetic distances with the quadratic regression line
ggplot(data = filtered_data, aes(x = fitted, y = obsrvd)) + 
  geom_point(pch = 21, size = 5) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, color = "black") +
  xlab("Great circle distance between demes (km)") +
  ylab("Genetic dissimilarity between demes") +
  scale_x_continuous(breaks = seq(0, 5000, by = 500)) +
  scale_y_continuous(labels = scales::label_number(accuracy = 0.01)) +
  theme_bw() +
  theme(axis.title = element_text(size = 15, color = "black"),
        axis.text = element_text(size = 12, color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
