# 0. Packages upload

# install needed packages
install.packages("cld2")
install.packages("tidyverse")
install.packages("syuzhet")
install.packages("reshape2")

# load packages
library(cld2)
library(tidyverse)
library(syuzhet)
library(reshape2)

# 1. Prepare Goodreads corpus

# find all files' addresses
all_goodreads_files <- list.files(path = "corpora", pattern = "Goodreads_", full.names = T)

# read the first file to prepare the dataframe
my_df <- read.csv(all_goodreads_files[1], row.names = 1, stringsAsFactors = F)

# get just text and book
my_df <- my_df[,c("book", "review")]

# iterate on the other files (if there are...)
if(length(all_goodreads_files) > 1){
  
  for(i in 2:length(all_goodreads_files)){
    
    # read datasets one by one
    my_tmp_df <- read.csv(all_goodreads_files[i], row.names = 1, stringsAsFactors = F)
    my_tmp_df <- my_tmp_df[,c("book", "review")]
    
    # concatenate
    my_df <- rbind(my_df, my_tmp_df)
    
  }
  
}

# exclude the "NA" reviews (probably due to errors in the scraping)
my_df <- my_df[!is.na(my_df$review),]

# add language (because - at the moment - we need to focus just on English)
my_df$language <- sapply(my_df$review, function(x) detect_language(text = x))

# some stats
my_df %>% count(language)

# reduce to just eng
my_df <- my_df %>% filter(language == "en")

# remove the info on language (now useless)
my_df$language <- NULL

# 2. Find basic emotions in reviews 

# let's find emotional values for one review
get_nrc_sentiment(my_df$review[1])

# let's add these values to all reviews
emotion_values <- data.frame()

# iterate on all reviews
for(i in 1:length(my_df$review)){
  
  emotion_values <- rbind(emotion_values, get_nrc_sentiment(my_df$review[i]))
  
}

# normalize per review length
my_df$length <- lengths(strsplit(my_df$review, "\\W"))

# iterate on all reviews
for(i in 1:length(my_df$review)){
  
  emotion_values[i,] <- emotion_values[i,]/my_df$length[i]
  
}

# then we can unite the dataframes
my_df <- cbind(my_df, emotion_values)

# ...and view the result
View(my_df)

# visualization via boxplot
# melt dataframe
my_df_melt <- melt(my_df)

# remove lengths
my_df_melt <- my_df_melt %>% filter(variable != "length")

# make plot
my_plot <- ggplot(my_df_melt, aes(x=variable, y=value, fill=book))+
  geom_boxplot(position = "dodge")+
  theme(axis.text.x = element_text(angle = 90, hjust=1))
my_plot

# save plot
ggsave(my_plot, filename = "figures/Goodreads_SA.png", height = 9, width = 16, scale = 0.7)


### Your Turn

# repeat the same, but for different books... 


