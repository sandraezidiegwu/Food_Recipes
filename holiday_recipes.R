setwd("/Users/sandraezidiegwu/Documents/Data Works/Data Incubator/Project/")

library(RSelenium) 
library(XML)
library(stringr)
library(plyr)
library(dplyr)

checkForServer() #search for and download Selenium Server
startServer() #run Selenium server
remDr <- remoteDriver(browserName = "chrome", port = 4444) #connect remote driver to Selenium server
remDr$open(silent = T) #this opens up web browser

holidayurls <- c(193, 188, 1509, 191, 1502, 1640, 189, 198, 187)  #list of holiday pages I was interested in

#created a for loop to scrape data for recipes by holiday
for (i in 1:length(holidayurls)) {
  allrecipes <- str_c('https://allrecipes.com/recipes/', holidayurls[i]) #str_c works like paste0 to join elements to one string. Here I create my urls.
  
  remDr$navigate(allrecipes) #navigate to webpage
  holiday <- remDr$findElement(using = "class name", value = "title-section__text") #gets a table of a text string
  holiday$highlightElement() #optional, this highlights where the attribute is being pulled from
  holidays <- holiday$getElementText() #this grabs the text in-between tags which is what i needed
  idlist <- remDr$findElements(using = "class name", value = "favorite")
  
  recipe.id <- lapply(idlist, function(x) x$getElementAttribute("data-id")) #creates list of url ids for individual recipes in holiday recipes pages
  recipeid <- unlist(recipe.id)
  
  #created another for loop for individual recipes and scraped some more stuff
  for (j in 1:length(recipeid)) {
    urls <- str_c("https://allrecipes.com/recipe/", recipeid[j]) #simply generates a new urls
    remDr$navigate(urls) $navigates to those url pages
    
    #the following are to pull recipe name, star rating, review count and # of people who made the recipe
    recipename <- remDr$findElement(using = "class name", value = "recipe-summary__h1")
    recipe.name <- recipename$getElementText()
    stars <- remDr$findElement(using = "class name", value = "rating-stars")
    star.rate <- stars$getElementAttribute("data-ratingstars")
    review <- remDr$findElement(using = "class", value = "review-count")
    review.count <- review$getElementText()
    madeit <- remDr$findElement(using = "class", value = "made-it-count")
    madeit.count <- madeit$getElementText()
    
    attr.table <- cbind(unlist(holidays), unlist(recipe.name), unlist(star.rate), unlist(review.count), unlist(madeit.count))
    colnames(attr.table) <- c("holiday", "recipe", "star_rate", "review_count", "madeit_count") #column bind to create vector of attributes
    
    #if else functions to write attr.table for all recipes into a one table by holiday for later use
    if (j == 1) {
      write.table(attr.table, paste0(unlist(holidays), ".txt"), row.names = F)
    } else {
      write.table(attr.table, paste0(unlist(holidays), ".txt"), append = T, row.names = F, col.names = F) #the append function allows you to insert row into an existing data frame
    }
  }
}
remDr$close() #closes web browser

#merge and clean up holiday recipes
filelist <- list.files(path = c("/Users/sandraezidiegwu/Documents/Data Works/Data Incubator/Project/"), pattern = ".txt")
txt.merge <- lapply(filelist, fread, sep = " ")
holiday.recipes <- data.frame(Reduce(rbind, txt.merge))

holiday.recipes$holiday <- gsub("Recipes", "", holiday.recipes$holiday)
holiday.recipes$star_rate <- round(as.numeric(holiday.recipes$star_rate), 2)
holiday.recipes$review_count <- gsub("reviews", "", holiday.recipes$review_count)
holiday.recipes$review_count <- as.numeric(holiday.recipes$review_count)
holiday.recipes$madeit_count <- gsub("K", "000", holiday.recipes$madeit_count)
holiday.recipes$madeit_count <- as.numeric(holiday.recipes$madeit_count)

#write cleaned table to a new file 'holiday_recipes.csv': 16kb (rather small)
write.csv(holiday.recipes, file = "./holiday_recipes.csv", row.names = F)

