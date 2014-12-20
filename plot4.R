## Assumes this project is the current working directory
source("prepare.R")

## Update locale in order to have the right labels
locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

## Load data
data <- getData()
nei <- data$NEI
scc <- data$SCC

## Filter with coal combustion-related sources
## Grep usage question from SO: http://stackoverflow.com/questions/13043928
coal.based.scc <- scc[grep("coal", scc$Short.Name, ignore.case = TRUE), ]$SCC
coal.emissions <- nei[nei$SCC %in% coal.based.scc, ]

## Compute total emissions by year using aggregate
emissions <- aggregate(
    coal.emissions$Emissions,
    list(coal.emissions$year),
    sum
)

## Create chart
png("plot4.png", width = 480, height = 480)
plot(
    emissions,
    main = "Coal combustion-related emissions in the US from 1999 to 2008", 
    xlab = "Year",
    ylab = "Emissions (tons)",
    type = "o",
    pch = 16, # full circle
    col = "orange",
    bg = "orange"
)
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
