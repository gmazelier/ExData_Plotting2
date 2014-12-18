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

## Compute total emissions by year using aggregate
emissions <- aggregate(
    baltimore$Emissions,
    list(baltimore$year),
    sum
)

## Create chart
png("plot2.png", width = 480, height = 480)
plot(
    emissions,
    main = "Total emissions in Baltimore City (Maryland) from 1999 to 2008", 
    xlab = "Year",
    ylab = "Emissions",
    type = "o",
    pch = 16, # full circle
    col = "blue",
    bg = "blue"
)
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
