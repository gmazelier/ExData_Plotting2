library(ggplot2)
library(grid)

## Assumes this project is the current working directory
source("prepare.R")

## Update locale in order to have the right labels
locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

## Load data
data <- getData()
nei <- data$NEI
scc <- data$SCC

## Filter with fips equals to 24510
baltimore <- nei[nei$fips == "24510",]

## Compute emissions by type and year using aggregate
emissions <- aggregate(
    baltimore$Emissions,
    list(baltimore$type, baltimore$year),
    sum
)
names(emissions) <- c("Type", "Year", "Emissions")

## Create chart
png("plot3.png", width = 480, height = 480)
# plot(
#     emissions,
#     main = "Total emissions in Baltimore City (Maryland) from 1999 to 2008", 
#     xlab = "Year",
#     ylab = "Total emissions",
#     type = "b",
#     col = "blue"
# )
ggplot(emissions, aes(Year, Emissions, group = Type, colour = Type)) +
    scale_colour_discrete(
        name = "Type",
        breaks = c("NONPOINT", "NON-ROAD", "ON-ROAD", "POINT"),
        labels = c("nonpoint", "nonroad", "onroad", "point")
    ) +
    ggtitle("Emissions/type in Baltimore City (Maryland) from 1999 to 2008") +
    xlab("Year") +
    ylab("Emissions") +
    theme_bw() +
    theme(plot.title = element_text(face = "bold", vjust = 3)) +
    theme(plot.margin = unit(c(1, 0.25, 0.25, 0.25), "cm")) +
    theme(legend.position = "bottom") +
    theme(legend.key = element_blank()) +
    geom_line() + geom_point()
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
