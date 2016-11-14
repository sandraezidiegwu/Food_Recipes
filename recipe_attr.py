from bs4 import BeautifulSoup

def recipe_attr(driver, holiday, id):
    #This is called when user wants to scrape for specific recipe site

    #recipe title
    rtitle = driver.find_element_by_tag_name('h1').text

    #Star rating
    starrating = driver.find_element_by_css_selector('div').get_attribute('data-ratingstars')

    #Number of people who clicked that they "made it"
    madeitcount = driver.find_element_by_css_selector("span.made-it-count.ng-binding")

    for reviewcount in driver.find_element_by_xpath("//span[@class = 'review-count']"):
        print (reviewcount.text)
        reviewcount = str(re.findall('(\w+) reviews', reviewcount)[0])

    #Update mongoDB with recipe entry
    temp = {'idnumber': id, 'holiday': holiday, 'recipe_title': rtitle.encode('ascii', 'ignore'), \
            'star_rating': starrating, 'made_it_count': madeitcount, 'review_count': reviewcount}

    collection.insert(temp)
