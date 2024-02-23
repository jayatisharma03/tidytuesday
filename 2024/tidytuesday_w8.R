library(tidytuesdayR)
library(dplyr)
library(tidyverse)
library(ggthemes)
library(scales)

library(tokenizers) #convert natural language text into tokens

tuesdata <- tidytuesdayR::tt_load(2024, week = 8)

isc_grants <- tuesdata$isc_grants
isc_grants <- isc_grants %>%
  mutate(Cycle = case_when(group == 1 ~ "Spring Cycle",
                           group == 2 ~ "Fall Cycle"))

ggplot(isc_grants, aes(x = year, y = funded, fill = Cycle)) +
  geom_bar(stat = "identity", width = 0.70) +
  labs(title = "ISC Grants Funding over the Years",
       x = "Year",
       y = "Funding Amount",
       caption = "Data: R Consortium ISC Funded Projects | Chart by Jayati Sharma") +
  scale_fill_manual(values = c("Spring Cycle" = "#FFC2C3", "Fall Cycle" = "#D39470")) +
  scale_x_continuous(breaks = unique(isc_grants$year)) +
  scale_y_continuous(labels = scales::comma) + 
  coord_flip()+
  theme_minimal()+
  theme(legend.position = "bottom",
        plot.title = element_text(size = 20, face = "bold"))

ggsave(filename = "ttw.jpg")