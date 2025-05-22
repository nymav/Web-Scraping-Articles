# Neural Development Articles Web Scraping

This R script scrapes article details from the Neural Development journal website for a given year and analyzes the extracted data.

## Dependencies

- `rvest`
- `dplyr`
- `ggplot2`
- `stringr`

## How to Use

Install the required libraries if not already installed:

   ```R
   install.packages("rvest")
   install.packages("dplyr")
   install.packages("ggplot2")
   install.packages("stringr")

The script will scrape article details, create a dataset, and generate visualizations.

Functionality
The script constructs a URL for a specific year, reads the HTML, and extracts article details such as title, authors, correspondence author, published date, abstract, and keywords.

The extracted data is stored in a data frame.

The published date is converted to a standard format, and the month is extracted and factorized.

Two visualizations are generated:

A bar plot showing the number of articles published per month.
A scatter plot showing the distribution of the number of authors per article.
Output
The script produces visualizations and saves the extracted data in a data frame.

In this README file, I've provided information about dependencies, how to use the script, the functionality of the script, the output it generates, and a note about respecting website terms and conditions. Feel free to customize it according to your project's specifics.
