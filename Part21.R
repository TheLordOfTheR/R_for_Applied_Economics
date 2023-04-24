#install.packages("ecb")

# Load required libraries
library(ecb)
library(ggplot2)

# Define the SDW series key and filter options
key <- "ICP.M.U2.N.000000.4.ANR"
filter <- list(detail = "full")

# Get the data from ECB Data Warehouse and convert dates
inflation <- get_data(key, filter)
inflation$obstime <- convert_dates(paste0(inflation$obstime,"-01"))

# Create the plot of inflation in the EU
ggplot(inflation, aes(x = obstime, y = obsvalue)) +
  geom_line(group = 1) +                          # Add a line to the plot
  theme_bw(8) +                                    # Use black and white theme
  theme(legend.position = "bottom") +              # Position legend at the bottom
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + # Rotate x-axis text
  labs(x = NULL, y = "Percent per annum\n",        # Set axis labels and title
       title = "Inflation in EU")
