import os
from selenium import webdriver

chromedriver = "/Users/sandraezidiegwu/Downloads/chromedriver"
os.environ["webdriver.chrome.driver"] = chromedriver
driver = webdriver.Chrome(chromedriver)

holidayurls = [191, 187, 1509, 188, 189, 1640, 198, 1502, 193]

for i in range(1,9):
        driver.get('https://allrecipes.com/recipes/' + str(holidayurls[i]))

html_list = driver.find_element_by_id("grid")
urls = html_list.find_elements_by_class_name("favorite")

#All holiday recipes have hearts associated with them. Inside 
#the heart contains the unique ID number for the given recipe

for i in range(len(urls)):
    	id('data-id')
    	urls[i] = ('https://allrecipes.com/recipes/' + str(id))
    	

#go to each individual recipe to scrape
holiday = driver.find_element_by_tag_name('title').text

from recipe_attr import recipe_attr
for i, url in enumerate(urls):
    driver.get(url)
    recipe_attr(driver, holiday, id)
