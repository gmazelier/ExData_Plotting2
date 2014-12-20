## Assumes this project is the current working directory
source("prepare.R")

## Update locale in order to have the right labels
locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

## Load data
data <- getData()
nei <- data$NEI
scc <- data$SCC

## All vehicule emissions match onroad category, as shown below:
#> grep.res <- scc[grep("vehicule", scc$Short.Name, ignore.case = TRUE), ]$SCC
#> category.res <-scc[scc$Data.Category == "ON-ROAD",]$SCC
#> all.equal(grep.res, category.res)
#[1] TRUE

## Filter with fips equals to 24510 and type ON-ROAD
baltimore <- nei[nei$fips == "24510" & nei$type=="ON-ROAD",]

## Compute total emissions by year using aggregate
emissions <- aggregate(
    baltimore$Emissions,
    list(baltimore$year),
    sum
)

## Create chart
png("plot5.png", width = 480, height = 480)
plot(
    emissions,
    main = "Motor vehicle emissions in Baltimore City (Maryland)\nfrom 1999 to 2008", 
    xlab = "Year",
    ylab = "Emissions",
    type = "o",
    pch = 16, # full circle
    col = "violet",
    bg = "violet"
)
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
