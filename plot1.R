## Assumes this project is the current working directory
source("prepare.R")

## Update locale in order to have the right labels
locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

## Load data
data <- getData()
nei <- data$NEI
scc <- data$SCC

## Compute total emissions by year using aggregate
emissions <- aggregate(
    nei$Emissions,
    list(nei$year),
    sum
)

## Create chart
png("plot1.png", width = 480, height = 480)
options(scipen = 999)
plot(
    emissions,
    main = "Total emissions in the United States from 1999 to 2008",
    xlab = "Year",
    ylab = "Emissions (tons)",
    type = "o",
    pch = 16, # full circle
    col = "red",
    bg = "red"
)
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
