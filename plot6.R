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

## All vehicule emissions match onroad category, as shown below:
#> grep.res <- scc[grep("vehicule", scc$Short.Name, ignore.case = TRUE), ]$SCC
#> category.res <-scc[scc$Data.Category == "ON-ROAD",]$SCC
#> all.equal(grep.res, category.res)
#[1] TRUE

## Filter with fips equals to 24510 or 06037 and ON-ROAD type
## Or condition: http://stackoverflow.com/questions/4935479
emissions <- nei[
    (nei$fips == "24510" | nei$fips == "06037") & nei$type=="ON-ROAD",
    ]

## Compute total emissions by year using aggregate
emissions <- aggregate(
    emissions$Emissions,
    list(emissions$fips, emissions$year),
    sum
)
names(emissions) <- c("City", "Year", "Emissions")

## Build a labelling function for facets
## See: http://stackoverflow.com/questions/3472980
city.names <- list(
    "06037" = "Los Angeles County",
    "24510" = "Baltimore City"
)
cityLabeller <- function(variable, value) {
    city.names[value]
}

## Create chart
png("plot6.png", width = 480, height = 480)
ggplot(emissions, aes(factor(Year), Emissions, fill = City)) +
    ggtitle(
        paste(
            c("Motor vehicle emissions in Los Angeles County (California)",
              "and Baltimore City (Maryland) from 1999 to 2008"),
            collapse = "\n "
        )
    ) +
    xlab("Year") +
    ylab("Emissions") +
    scale_fill_discrete(name = "Year") +
    theme_bw() +
    theme(plot.title = element_text(face = "bold", vjust = 3)) +
    theme(plot.margin = unit(c(1, 0.25, 0.25, 0.25), "cm")) +
    theme(legend.position = "bottom") +
    theme(legend.key = element_blank()) +
    geom_bar(
        aes(fill = factor(Year)),
        stat = "identity",
    ) +
    facet_grid(
        . ~ City,
        labeller = cityLabeller
    )
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
