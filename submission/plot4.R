## The following piece of code could be extracted in its own R script and
## shared across the different plotting scripts in a "prepare.R" file. But
## due to the submission process for this project, it is duplicated between
## the files. Specific code for each question begins after the "Question x"
## comment.

fetchData <- function(src, dst) {
    res <- length(Filter(file.exists, dst))
    if (length(dst) != res) {
        target <- "data.zip"
        message(sprintf("Downloading data from '%s'", src))
        download.file(src, target, method = "curl", quiet = TRUE)
        message(sprintf("Extracting to '%s'\n", dst))
        unzip(target)
    } else {
        message(sprintf("File '%s' already exists, skipping download\n", dst))
    }
}

getData <- function() {
    src <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    dst <- c("summarySCC_PM25.rds", "Source_Classification_Code.rds")
    fetchData(src, dst)
    
    data <- lapply(dst, readRDS)
    data.names <- c("NEI", "SCC")
    names(data) <- data.names
    
    data
}

## Assumes this project is the current working directory
#source("prepare.R")

##
## Question 4
##

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
