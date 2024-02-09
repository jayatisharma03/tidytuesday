##loading packages and data
library(tidytuesdayR)
library(waffle)
library(extrafont)
library(dplyr)
library(gridExtra)

tuesdata <- tidytuesdayR::tt_load('2024-02-06')
heritage_data <- as.data.frame(tuesdata$heritage)

##loading awesome 5 solid font for waffle chart

font_import()
loadfonts()

## Create individual waffle charts
chart_2004 <- waffle(c(Norway = 5, Denmark = 4, Sweden = 13), rows = 3, use_glyph = "archway", glyph_size = 6, 
                     colors = c("#00205B", "#C8102E", "#FECC02"), title = "2004")

chart_2022 <- waffle(c(Norway = 8, Denmark = 10, Sweden = 15), rows = 3, use_glyph = "archway", glyph_size = 6,
                     colors = c("#00205B", "#C8102E", "#FECC02"), title = "2022")

## Combining the two individual plots
combined_plot <- grid.arrange(chart_2004, chart_2022, nrow = 2, top = "UNESCO Heritage Sites in Norway, Denmark and Sweden")

## Adding data source
data_source_annotation <- ggdraw(combined_plot) +
  draw_label("Data Source: UNESCO World Heritage List | Chart by Jayati Sharma", x = 0.5, y = 0.02, hjust = 0.5, size = 10)

data_source_annotation