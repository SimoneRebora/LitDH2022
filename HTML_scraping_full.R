# HTML_scraping_full

# Welcome!
# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter
# (the command will be automatically copy/pasted into the console)

# define the link (here we take "War and Peace" in Goodreads)
my_link <- "https://www.goodreads.com/book/show/656.War_and_Peace"

# call rvest library (and install if needed)
if (!require("rvest")) install.packages("rvest")

# read the link
doc <- read_html(my_link)

full_reviews <- doc %>% html_nodes(xpath = "//div[@class='friendReviews elementListBrown']")

# extended iteration (getting both text, author, and date)
my_reviews <- character()
my_authors <- character()
my_dates <- character()

for(i in 1:length(full_reviews)){
  
  my_reviews[i] <- full_reviews[[i]] %>% html_node(css = "[style='display:none']") %>% html_text() # improved: we get the hidden text
  my_authors[i] <- full_reviews[[i]] %>% html_node(css = "[class='user']") %>% html_text()
  my_dates[i] <- full_reviews[[i]] %>% html_node(css = "[class='reviewDate createdAt right']") %>% html_text()
  
}

my_text <- gsub(pattern = "https://www.goodreads.com/book/show/", replacement = "", my_link, fixed = T)

# save all
my_df <- data.frame(book = my_text, author = my_authors, date = my_dates, review = my_reviews)

write.csv(my_df, file = paste("corpora/Goodreads_", my_text, ".csv", sep = ""))

### Your Turn
# try to scrape another title
# ...for doing it, you will have to change the link at line 13
# Important: try to keep the same link structure, because
# some rubbish might be added at the end if you search for a different book
# e.g. 
# https://www.goodreads.com/book/show/338798.Ulysses?ac=1&from_search=true&qid=9sjp4ldVfm&rank=1
# better write:
# https://www.goodreads.com/book/show/338798.Ulysses
#
# then if you feel confident, you can try an retrieve more information for each review
# for example the "shelves"