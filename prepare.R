## This utility script will fetch the required data.
## Usage: data <- getData()

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
