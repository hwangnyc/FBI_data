library(httr)
library(jsonlite)
library(dplyr)

# States including territories
states <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "PR", "VI")

# Your API key
api_key <- "ATbr073I6fRVyYorrH9Blq5TefFLPVrITYFXSzqp"

# Function to fetch data for a given state
fetch_state_data <- function(state) {
  url <- paste0("https://api.usa.gov/crime/fbi/cde/agency/byStateAbbr/", state, "?API_KEY=", api_key)
  response <- GET(url)
  if (http_status(response)$category == "Success") {
    json_data <- content(response, "text") # Extract JSON content
    data_frame <- fromJSON(json_data)     # Convert JSON to data frame
    return(data_frame)
  } else {
    return(NULL)
  }
}

# Loop through each state, fetch data, and store in a list
state_data_frames <- list()
for (state in states) {
  print(paste("Fetching data for", state))  # Print statement to display progress
  state_data <- fetch_state_data(state)
  if (!is.null(state_data)) {
    state_data_frames[[state]] <- state_data
  }
}

#Make a single dataframe
state_df <- bind_rows(state_data_frames)

#get a list of all police department codes
pd_ori<-unique(c(state_df$ori))
