#loading the data and libraries
tuesdata <- tidytuesdayR::tt_load('2023-12-05')

life_expectancy <- tuesdata$life_expectancy
life_expectancy_different_ages <- tuesdata$life_expectancy_different_ages
life_expectancy_female_male <- tuesdata$life_expectancy_female_male

library(tidyverse) #data cleaning and wrangling
library(stringr) #string manipulation
library(ggplot2) #for visualizations
library(gganimate) #for animation
library(unhcrthemes) #for a clean plot theme

#attaching year to country to make a unique column for the data frame
life_expectancy$unique_col <- str_c(life_expectancy$Entity, '_' , life_expectancy$Year)
life_expectancy_female_male$unique_col <- str_c(life_expectancy_female_male$Entity, '_' , life_expectancy_female_male$Year)

#merging the two data frame
full_data_life_ex <- merge(life_expectancy, life_expectancy_female_male, by = "unique_col")

#cleaning the new data frame
full_data_life_ex <- full_data_life_ex %>%
  select(-Entity.x,-Code.x, -Year.x,) %>%
  rename("Entity" = "Entity.y", "Code" = "Code.y", "Year" = "Year.y")

#making the plot
p <- full_data_life_ex %>%
  filter(Year >= 1900) %>%
  ggplot(aes(x = LifeExpectancy, y = LifeExpectancyDiffFM, size = 1.8, color = Entity)) +
    geom_point()+
  ylim(-15, 35) +
  geom_hline(yintercept = 0, colour = "black", linetype = 2) +
  labs(y = "Difference in Life Expectancy between Females and Males",
       x = "Life Expectancy",
       caption = "Data: Our World in Data | Graph: Jayati Sharma") +
  theme_unhcr(font_size =13,
              grid = TRUE,
              axis = TRUE,
              axis_title = TRUE)+
  theme(legend.position="none") +
  transition_time(as.integer(Year)) +
  shadow_mark(alpha = 0.4, size = 0.7)+
  labs(title = "Life Expectancy vs Difference in Life Expectancy between Females and Males, Year: {frame_time}")

#saving the plot
anim_save(filename="tidytuesdayw48.gif", p, fps = 10, height = 1000, width = 1000)
