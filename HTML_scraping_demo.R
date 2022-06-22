# HTML_scraping_demo

# Welcome!
# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# install rvest
install.packages("rvest") # remember, this should be done just once!!!

# call rvest library
library(rvest)

# define the link (here we take "War and Peace" in Goodreads)
my_link <- "https://www.goodreads.com/book/show/656.War_and_Peace"

# read the html to an R variable
doc <- read_html(my_link)

# then find the element in the HTML that identifies the reviews
doc %>% html_nodes(xpath = "//div[@class='friendReviews elementListBrown']")
# tip: you can use F12 in your browser to see the structure of the page
# you need to use Xpath expressions to find the relevant nodes
# info: https://www.w3schools.com/xml/xpath_syntax.asp

# once verified that it works, you can save it to a variable
full_reviews <- doc %>% html_nodes(xpath = "//div[@class='friendReviews elementListBrown']")

# ...and get the reviews one by one
full_reviews[[1]] %>% html_node(css = "[class='reviewText stacked']") %>% html_text()
# note: to search inside of HTML nodes, we need to use a different syntax, CSS selector
# info: https://www.w3schools.com/cssref/css_selectors.asp

# ...or the author
full_reviews[[1]] %>% html_node(css = "[class='user']") %>% html_text()

# ...or the date
full_reviews[[1]] %>% html_node(css = "[class='reviewDate createdAt right']") %>% html_text()

# to get the same data for another review
# ...you have just to change the number in square brackets
full_reviews[[2]] %>% html_node(css = "[class='reviewText stacked']") %>% html_text()
full_reviews[[2]] %>% html_node(css = "[class='user']") %>% html_text()
full_reviews[[2]] %>% html_node(css = "[class='reviewDate createdAt right']") %>% html_text()

# ...and so on