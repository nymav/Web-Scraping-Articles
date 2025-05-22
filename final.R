#load necessary libraries
library(rvest)
library(dplyr)
library(ggplot2)
library(stringr)

#set the year, construct the url and read the html
year<-2018
url<-paste0("https://neuraldevelopment.biomedcentral.com/articles?year=", year)
html_doc<-read_html(url)

#function to extract data for a given article in url
extract_data<-function(aurl) {
  aurl<-read_html(aurl)
  
  #extracts article details
  #title
  title<-aurl %>% 
    html_node(".c-article-title") %>% 
    html_text()
  #authors
  authors<-aurl %>% html_nodes("ul.c-article-author-list a[data-test='author-name']") %>% 
    html_text() %>% 
    paste(collapse=", ")
  #correspondence author
  correspondence_author<-aurl %>% 
    html_node("#corresp-c1") %>% 
    html_text()
  #correspondence email
  correspondence_email<-str_extract(aurl %>% html_node("#corresp-c1") %>% html_attr("href"),"mailto:(.*)") %>% 
    substring(8)
  #published date
  published_date<-aurl %>% 
    html_node("time") %>% 
    html_text()
  #abstract
  abstract<-aurl %>% 
    html_node("#Abs1-content p") %>% 
    html_text() %>% 
    trimws()
  # keywords
  keywords<-ifelse(nchar(aurl %>% html_nodes("ul.c-article-subject-list a[data-track-action='view keyword']") %>% 
                       html_text() %>% paste(collapse=", "))==0, NA, aurl %>% html_nodes("ul.c-article-subject-list a[data-track-action='view keyword']") %>% 
                       html_text() %>% trimws()%>%
                       paste(collapse = ", ")) 
  #create a data frame
  article_data<-data.frame(Title = title, Authors=authors,
                            Correspondence_Author=correspondence_author,
                            Correspondence_Author_Email=correspondence_email,
                            Published_Date=published_date,Abstract=abstract,
                            Keywords=keywords)
  return(article_data)
}

#extract links for all the articles on the page
article_links<-html_doc %>%
  html_nodes(".c-listing__title a") %>%
  html_attr("href") %>%
  paste0("https://neuraldevelopment.biomedcentral.com", .)

#use extract_data function to scrape data for each article
articles<-lapply(article_links, extract_data)

#combine the extracted data into a single data frame
article_data<-do.call(rbind, articles)

View(article_data)

#copy extracted data to a new variable
article_da<-article_data

#covert the published date
article_da$Published_Date<-format(as.Date(article_da$Published_Date,format="%d %B %Y"),"%m-%d-%Y")

#extract and factorize the month from the published date
article_da$Published_Month<-format(strptime(article_da$Published_Date,format="%m-%d-%Y"),"%B")
article_da$Published_Month<-factor(article_da$Published_Month,levels=month.name)

#create a bar plot for articles published per month
ggplot(article_da,aes(x=Published_Month)) +
  geom_bar(stat="count",color="black") +
  labs(title="Articles Published Per Month", 
       x="Month", 
       y="Number of Articles") + 
  scale_x_discrete(labels=month.abb)


# Create a scatter plot to show the distribution of the number of authors per article
article_da$Num_Authors<-sapply(strsplit(article_da$Authors, ", "),length)
ggplot(article_da,aes(x=Num_Authors)) +
  geom_point(stat = "count",fill="grey",color="black") +
  labs(title="Distribution of Authors per Article",
       x="Number of Authors",
       y="Number of Articles") +
  scale_x_continuous(breaks=seq(min(article_da$Num_Authors),max(article_da$Num_Authors),by=1)) +
  scale_y_continuous(breaks=seq(0,max(table(article_da$Num_Authors)),by=1))

