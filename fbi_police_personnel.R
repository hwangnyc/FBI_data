library(httr)
library(jsonlite)
library(dplyr)

# Assuming pd_ori contains values for the API call
pd_ori<-unique(c(state_df$ori))

# Your API key
api_key <- "Your API KEY HERE"

# Function to fetch data for a given pd_ori value
fetch_pd_data <- function(pd_ori_value) {
  url <- paste0("https://api.usa.gov/crime/fbi/cde/pe/agency/", pd_ori_value, "/byYearRange?from=2000&to=2023&API_KEY=", api_key)
  response <- GET(url)
  
  if (http_status(response)$category == "Success") {
    json_data <- content(response, "text") # Extract JSON content
    data_frame <- fromJSON(json_data)     # Convert JSON to data frame
    data_frame$pd_ori <- pd_ori_value     # Add a column for the pd_ori value
    return(data_frame)
  } else {
    return(NULL)
  }
}

# Loop through each pd_ori value, fetch data, and store in a list
pd_data_frames <- lapply(pd_ori, fetch_pd_data) %>%
  bind_rows()
