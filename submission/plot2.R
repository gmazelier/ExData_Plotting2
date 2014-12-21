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
## Question 2
##

## Update locale in order to have the right labels
locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

## Load data
data <- getData()
nei <- data$NEI

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
    ylab = "Emissions (tons)",
    type = "o",
    pch = 16, # full circle
    col = "blue",
    bg = "blue"
)
dev.off()

## Restore the locale
Sys.setlocale("LC_TIME", locale)
