## loading the essential libraries and data

library(tidyverse)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(gganimate)
library(unhcrthemes)
options(scipen = 10000)

tuesdata <- tidytuesdayR::tt_load(2025, week = 46)

who_data <- tuesdata$who_tb_data

#---------------------------------------------------------------------------------------------------------------------

## getting world map

world <- ne_countries(scale = "medium", returnclass = "sf")

target_crs <- "+proj=eqc"

world_moll <- world |>
  st_transform(crs = target_crs)

world_moll <- sf::st_transform(world_moll, crs = 4326)

world_moll <- world_moll |>
  select(name, name_long, brk_a3, geometry)

#---------------------------------------------------------------------------------------------------------------------

## getting entries for all years and all countries

all_countries <- world_moll$brk_a3
all_years <- unique(who_data$year)

full_grid <- expand_grid(brk_a3 = all_countries, year = all_years)

who_full <- full_grid |>
  left_join(who_data, by = c("brk_a3" = "iso3", "year" = "year"))

world_full <- world_moll |>
  left_join(who_full, by = "brk_a3")

#---------------------------------------------------------------------------------------------------------------------

## plotting the map

p <- world_full |>
  ggplot() +
  geom_sf(aes(fill = e_mort_100k), color = NA) +
  scale_fill_gradientn(
    colours = c("#FFE7A0", "#FFDBBB", "#FE9929", "#D95F0E","#800026"),
    na.value = "grey90") +
  coord_sf(expand = FALSE, clip = "off") +  
  labs(title = "Mortality from TB in {frame_time}",
    fill = "Mortality",
    caption = "Data: WHO | Map by Jayati Sharma") +
  theme_unhcr(font_size =15,
                grid = TRUE,
                axis = FALSE,
                axis_title = FALSE)+
  theme(legend.position = "bottom",
    legend.key.width = unit(3.5, "cm"),   
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 17, face = "bold"),
    legend.box = "horizontal")+
  transition_time(as.integer(year)) +
  labs(title = "Estimated mortality (per 100,000 population ) of TB cases around the world, Year: {frame_time}")

anim_save(filename="tidytuesdayw_25_46.gif", p, fps = 10, height = 1000, width = 1000)
