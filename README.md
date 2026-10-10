# Neural Development Article Analysis

An R workflow for collecting article metadata from the Neural Development journal and visualising publication patterns.

## Run

Install the required packages in R:

```r
install.packages(c("rvest", "dplyr", "ggplot2", "stringr"))
```

Open [final.R](final.R), review the target year and journal URL, and run the script in R or RStudio. Internet access is required to retrieve the source pages.

## Output

The script collects article details, including titles, authors, publication dates, abstracts, and keywords, into a data frame. It generates plots of articles published per month and the number of authors per article.

## Notes

The extraction depends on the journal’s HTML structure. Check the collected fields when the source website changes, and follow its access policies.
