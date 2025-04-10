library(leaflet)
library(sf)
library(readr)
library(dplyr)   
library(ggplot2)
library(mgcv)    
library(psych)   
library(plotly)
library(htmltools)
library(RColorBrewer)


# 1st Dataset
# Importing Data
export_data <- read_csv("DDA02.20250317T140346.csv")


#Select only necessary columns
earning_estimates <- export_data %>% 
  select(`Statistic Label`, Year, Sex, `NACE Rev 2 Sector`,`Age Group`,VALUE )


#Renaming the columns
earning_estimates <- earning_estimates  %>% rename( Metrics = `Statistic Label`,
                                           Calender_Year = Year,
                                           Sector = `NACE Rev 2 Sector`,
                                           Age_Group =`Age Group`,
                                           Euros = VALUE)


#Unique values in Metrics

earning_estimates %>% distinct(Metrics)

# Dropping rows with unwanted Metrics
earning_estimates <- earning_estimates %>% filter(!Metrics %in% c("Annual Change (Mean Weekly Earnings)", 
                                                                  "Annual Change (Median Weekly Earnings)",
                                                                  "Annual Change (Mean Annual Earnings)",
                                                                  "Annual Change (Median Annual Earnings)",
                                                                  "Median Weekly Earnings",
                                                                  "Median Annual Earnings"
                                                                  ))


earning_estimates <- earning_estimates %>% filter(!Sex %in% c("Both sexes"))



earning_estimates %>% count(Metrics)


# weekly_earning_estimates
weekly_earning_estimates <- earning_estimates  %>% 
  filter(Metrics == "Mean Weekly Earnings")



agg_weekly_earning_estimates <- weekly_earning_estimates %>% group_by(Sector, Calender_Year, Age_Group) %>% 
 summarise(
    Total_Euros = sum(Euros, na.rm = TRUE))
print(agg_weekly_earning_estimates)


# annual_earning_estimates
annual_earning_estimates <- earning_estimates  %>% 
  filter(Metrics == "Mean Annual Earnings")


agg_annual_earning_estimates <- annual_earning_estimates %>% group_by(Sector, Calender_Year, Age_Group) %>% 
  summarise(
    Total_Euros = sum(Euros, na.rm = TRUE))
print(agg_annual_earning_estimates)



## Table 2
export_data <- read_csv("DDA11.20250317T170356.csv")
print(export_data)

earning_percentiles <- export_data  %>% rename( Metrics = `Statistic Label`,
                                                Calender_Year = Year,
                                                Age_Group =`Age Group`,
                                                Euros = VALUE)
print(earning_percentiles)

earning_percentiles %>% distinct(Metrics)


# Dropping rows with unwanted Metrics
earning_percentiles <- earning_percentiles %>% filter(!Metrics %in% c("Annual Change (Weekly Earnings)", 
                                                                  "Annual Change (Annual Earnings)"))


# weekly_earning_percentiles

weekly_earning_percentiles <- earning_percentiles  %>% 
  filter(Metrics == "Weekly Earnings")

agg_weekly_earning_percentiles <- weekly_earning_percentiles %>% group_by(Calender_Year, Percentile,Age_Group ) %>% 
  summarise(
    Total_Euros = sum(Euros, na.rm = TRUE))



# annual_earning_percentiles

annual_earning_percentiles <- earning_percentiles  %>% 
  filter(Metrics == "Annual Earnings")

agg_annual_earning_percentiles <- annual_earning_percentiles %>% group_by(Calender_Year, Percentile, Age_Group) %>% 
  summarise(
    Total_Euros = sum(Euros, na.rm = TRUE))

# Joining 4 Tables
# Merge weekly and annual earning estimates (Sector-based)
earning_estimates <- full_join(weekly_earning_estimates, annual_earning_estimates, 
                               by = c("Sector", "Calender_Year", "Age_Group"), 
                               suffix = c("_Weekly", "_Annual"))

# Merge weekly and annual earning percentiles (Percentile-based)
earning_percentiles <- full_join(weekly_earning_percentiles, agg_annual_earning_percentiles, 
                                 by = c("Calender_Year", "Percentile", "Age_Group"), 
                                 suffix = c("_Weekly", "_Annual"))

# Final merge of both tables based on Calender_Year and Age_Group
final_merged_data <- full_join(earning_estimates, earning_percentiles, 
                               by = c("Calender_Year", "Age_Group"))

# View the merged dataset
head(final_merged_data)


## Descriptive Statistics
df <- final_merged_data

# Check structure of the data
str(df)

# Convert categorical variables to factors
df$Sector <- as.factor(df$Sector)
df$Age_Group <- as.factor(df$Age_Group)
df$Calender_Year <- as.integer(df$Calender_Year)  # Ensure year is numeric


# Summary statistics for Total_Euros (weekly & annual)
summary(df[, c("Euros_Weekly", "Euros_Annual")])

# More detailed stats
describe(df[, c("Euros_Weekly", "Euros_Annual")])

# Standard deviation & variance
sd(df$Euros_Weekly, na.rm = TRUE)
var(df$Euros_Weekly, na.rm = TRUE)

sd(df$Euros_Annual, na.rm = TRUE)
var(df$Euros_Annual, na.rm = TRUE)


# Boxplot for Weekly vs Annual Earnings
# Weekly Earnings Distribution
fig_weekly <- plot_ly(df, 
                      x = ~Age_Group, 
                      y = ~Euros_Weekly, 
                      type = "box", 
                      boxmean = "sd", 
                      marker = list(color = 'rgba(0, 123, 255, 0.7)', # Transparent blue
                                    line = list(color = 'rgba(0, 123, 255, 1)', width = 2)), 
                      fillcolor = 'rgba(0, 123, 255, 0.4)', 
                      jitter = 0.3) %>%
  layout(title = "Weekly Earnings Distribution by Age Group", 
         title_x = 0.5, 
         title_y = 1.1, 
         xaxis = list(title = "Age Group",
                      tickangle = 45, 
                      titlefont = list(size = 14)),
         yaxis = list(title = "Total Euros (Weekly)",
                      titlefont = list(size = 14)),
         plot_bgcolor = 'rgba(245, 245, 245, 1)',  # Light gray background
         paper_bgcolor = 'rgba(255, 255, 255, 1)', # White paper background
         showlegend = FALSE)

fig_weekly  # Display the plot


# Annual Earnings Distribution 
fig_annual <- plot_ly(df, 
                      x = ~Age_Group, 
                      y = ~Euros_Annual, 
                      type = "box", 
                      boxmean = "sd", 
                      marker = list(color = 'rgba(255, 99, 132, 0.7)', # Transparent red
                                    line = list(color = 'rgba(255, 99, 132, 1)', width = 2)), 
                      fillcolor = 'rgba(255, 99, 132, 0.4)', 
                      jitter = 0.3) %>%
  layout(title = "Annual Earnings Distribution by Age Group", 
         title_x = 0.5, 
         title_y = 1.1, 
         xaxis = list(title = "Age Group",
                      tickangle = 45, 
                      titlefont = list(size = 14)),
         yaxis = list(title = "Total Euros (Annual)",
                      titlefont = list(size = 14)),
         plot_bgcolor = 'rgba(245, 245, 245, 1)',  # Light gray background
         paper_bgcolor = 'rgba(255, 255, 255, 1)', # White paper background
         showlegend = FALSE)

fig_annual  # Display the plot



# Checking correlation between numeric variables
cor(df[, c("Euros_Weekly", "Euros_Annual")], use = "complete.obs")


# Interactive- Bar Chart - Earnings Trend Over Time
# Compute mean annual earnings per year
trend_data <- df %>%
  group_by(Calender_Year) %>%
  summarise(Avg_Annual_Earnings = mean(Euros_Annual, na.rm = TRUE))

# Create interactive line chart
p1 <- plot_ly(trend_data, x = ~Calender_Year, 
              y = ~Avg_Annual_Earnings, 
              type = "scatter", mode = "lines+markers",
              name = "Annual Earnings", 
              line = list(color = "blue")) %>%
  layout(title = "Earnings Trend Over the Years",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Earnings (€)"))

p1  # Display the plot

# Interactive Heatmap - Earnings Percentile Distribution

df_filtered <- df %>% 
  filter(Percentile != "5th percentile")

# Create heatmap excluding "5th Percentile"
p2 <- plot_ly(df_filtered, x = ~Calender_Year, y = ~Percentile, z = ~Total_Euros, 
              type = "heatmap", colorscale = "Blues") %>%
  layout(title = "Heatmap of Annual Earnings Percentile Distribution",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Percentile"),
         colorbar = list(title = "Earnings (€)"))

p2  # Display the plot



# 3rd Dataset
# Importing Data
export_data <- read_csv("DEA08.20250323T180312.csv")

#Select only necessary columns
geo_distrbution <- export_data %>% 
  select(Year,County,`NACE Rev 2 Economic Sector`,VALUE )
 
# Rename the columns
geo_distrbution <- geo_distrbution  %>% rename(Sector = `NACE Rev 2 Economic Sector`,
                                               Euros = VALUE) 
                                                
# Aggregating Data
geo_distrbution <- geo_distrbution %>% group_by(County, Year) %>% 
  summarise(
    Total_Euros = sum(Euros, na.rm = TRUE))
print(geo_distrbution)

## Geographical Analysis
# Imported Json file
counties_sf <- st_read("ie.json")
counties_sf$name <- paste0("Co. ", counties_sf$name)

# View the updated data
print(counties_sf)

counties_data <- counties_sf %>%
  left_join(geo_distrbution, by = c("name" = "County"))

# Check the structure of the merged data
head(counties_data)

# Create a color palette for the map
pal <- colorNumeric(palette = "YlGnBu", domain = counties_data$Total_Euros)


# Filter data for two specific years (2011 and 2021)
year_data_one <- counties_data %>%
  filter(Year == 2011)

year_data_two <- counties_data %>%
  filter(Year == 2021)

# Create color palette for Total Euros
pal <- colorNumeric(palette = "YlGnBu", domain = counties_data$Total_Euros)

# Create map for 2011
map_one <- leaflet(data = year_data_one) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Total_Euros),
              fillOpacity = 0.7,
              color = "white",
              weight = 1,
              popup = ~paste(name, "<br>", "Total Earnings: €", Total_Euros),
              label = ~name) %>%
  addLegend(pal = pal, values = ~Total_Euros, opacity = 0.7, title = "Total Earnings (€)", position = "bottomright")

# Create map for 2021
map_two <- leaflet(data = year_data_two) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Total_Euros),
              fillOpacity = 0.7,
              color = "white",
              weight = 1,
              popup = ~paste(name, "<br>", "Total Earnings: €", Total_Euros),
              label = ~name) %>%
  addLegend(pal = pal, values = ~Total_Euros, opacity = 0.7, title = "Total Earnings (€)", position = "bottomright")

# Combine both maps side by side using tagList and CSS styling
browsable(tagList(
  div(style = "display: inline-block; width: 48%;", map_one),
  div(style = "display: inline-block; width: 48%;", map_two)
))

## Inferential Analysis
# GLM model: Predicting Annual Earnings based on Weekly Earnings, Age Group, and Sector
glm_model <- glm(Euros_Annual ~ Euros_Weekly + Age_Group + Sector,
                 data = df, family = gaussian())

# Model Summary
summary(glm_model)

# GAM model: Adding smoothing function for Weekly Earnings
gam_model <- gam(Euros_Annual ~ s(Euros_Weekly) + Age_Group + Sector,
                 data = df, family = gaussian())

# Model Summary
summary(gam_model)

# Plot GAM effect
plot(gam_model, pages = 1)

# GAM model: Adding smoothing function for Weekly Earnings
gam_model <- gam(Euros_Annual ~ s(Euros_Weekly) + Age_Group + Sector,
                 data = df, family = gaussian())

# Model Summary
summary(gam_model)

# Plot GAM effect
plot(gam_model, pages = 1)

# Checking Residuals
par(mfrow = c(2, 2)) # Multiple plots
plot(glm_model)

# Check R-squared for GAM
rsq <- 1 - sum(resid(gam_model)^2) / sum((df$Euros_Annual - mean(df$Euros_Annual, na.rm = TRUE))^2)
print(paste("R-squared of GAM model:", round(rsq, 3)))

## Gender pay gap analysis

# Calculate gender pay gap

gender_data <- read_csv("DDA02.20250317T140346.csv") %>%
  filter(Sex %in% c("Male", "Female")) %>%
  rename(Metrics = `Statistic Label`,
         Calender_Year = Year,
         Sector = `NACE Rev 2 Sector`,
         Age_Group = `Age Group`,
         Euros = VALUE)

# Calculate gender pay gap with additional metrics
gender_gap_enhanced <- gender_data %>%
  filter(Metrics == "Mean Annual Earnings") %>%
  group_by(Calender_Year, Sector) %>%  # Removed Age_Group for clearer sector trends
  summarise(
    Male_Earnings = mean(Euros[Sex == "Male"], na.rm = TRUE),
    Female_Earnings = mean(Euros[Sex == "Female"], na.rm = TRUE),
    Pay_Gap = (Male_Earnings - Female_Earnings) / Male_Earnings * 100,
    Ratio = Female_Earnings / Male_Earnings,
    Absolute_Gap = Male_Earnings - Female_Earnings,
    .groups = 'drop'
  ) %>%
  mutate(Sector = factor(Sector),
         Pay_Gap_Label = paste0(round(Pay_Gap, 1), "%"))

# Create custom color palette
sector_colors <- colorRampPalette(brewer.pal(8, "Set2"))(length(unique(gender_gap_enhanced$Sector)))

# Enhanced visualization
gap_plot_enhanced <- plot_ly() %>%
  
  # Main line plot for pay gap trends
  add_trace(
    data = gender_gap_enhanced,
    x = ~Calender_Year,
    y = ~Pay_Gap,
    color = ~Sector,
    colors = sector_colors,
    type = 'scatter',
    mode = 'lines+markers',
    line = list(width = 3),
    marker = list(size = 8),
    text = ~paste0(
      "<b>", Sector, "</b><br>",
      "Year: ", Calender_Year, "<br>",
      "Pay Gap: ", round(Pay_Gap, 1), "%<br>",
      "Male Earnings: €", format(round(Male_Earnings), big.mark = ","), "<br>",
      "Female Earnings: €", format(round(Female_Earnings), big.mark = ","), "<br>",
      "Absolute Difference: €", format(round(Absolute_Gap), big.mark = ",")),
    hoverinfo = 'text',
    name = ~Sector
  ) %>%
  
  # Reference line at zero
  add_segments(
    x = min(gender_gap_enhanced$Calender_Year),
    xend = max(gender_gap_enhanced$Calender_Year),
    y = 0,
    yend = 0,
    line = list(color = 'black', dash = 'dot'),
    showlegend = FALSE
  ) %>%
  
  layout(
    title = list(
      text = "<b>Gender Pay Gap Trends by Economic Sector</b>",
      x = 0.05,
      y = 0.98,
      font = list(size = 18)
    ),
    xaxis = list(
      title = "Year",
      tickvals = unique(gender_gap_enhanced$Calender_Year),
      gridcolor = 'lightgrey'
    ),
    yaxis = list(
      title = "Gender Pay Gap (%)",
      ticksuffix = "%",
      range = c(min(gender_gap_enhanced$Pay_Gap) - 5, 
                max(gender_gap_enhanced$Pay_Gap) + 5),
      gridcolor = 'lightgrey',
      zerolinecolor = 'black'
    ),
    plot_bgcolor = 'white',
    paper_bgcolor = 'white',
    margin = list(l = 60, r = 40, t = 80, b = 60),
    legend = list(
      orientation = 'h',
      x = 0.3,
      y = -0.3,
      font = list(size = 10)
    ),
    hoverlabel = list(
      bgcolor = 'white',
      font = list(size = 12)
    )
  ) %>%
  
  # Add annotations
  add_annotations(
    x = 0.5,
    y = 1.05,
    xref = "paper",
    yref = "paper",
    text = "<i>Positive values indicate men earn more than women</i>",
    showarrow = FALSE,
    font = list(size = 12, color = 'grey')
  )

# Add dropdown selector for different metrics
gap_plot_enhanced <- gap_plot_enhanced %>%
  layout(
    updatemenus = list(
      list(
        type = "dropdown",
        y = 1.15,
        x = 0.2,
        buttons = list(
          list(method = "restyle",
               args = list("y", list(~Pay_Gap)),
               label = "Pay Gap (%)"),
          list(method = "restyle",
               args = list("y", list(~Absolute_Gap)),
               label = "Absolute Gap (€)"),
          list(method = "restyle",
               args = list("y", list(~Ratio)),
               label = "Female/Male Ratio")
        )
      )
    )
  )

gap_plot_enhanced
















