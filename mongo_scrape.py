import numpy as np
import pymongo
import pandas as pd
# Connection to Mongo DB and import recipe and ingredients collections as Pandas
try:
    conn=pymongo.MongoClient()
    print "Connected successfully!!!"
except pymongo.errors.ConnectionFailure, e:
    print "Could not connect to MongoDB: %s" % e 
conn

recipesdb = conn['allrecipes']
collection = recipesdb['recipes']
df = pd.DataFrame(list(collection.find()))
df = df.set_index('idnumber')

#convert made it counter from units of K's into thousands
def madetocountfix(madecount):
    if re.search('K', madecount):
        madecount = re.sub('K', '000', madecount)
    return int(madecount)
        
#convert counter from K's to thousands and convert times into minutes
df.made_it_count = map(madetocountfix,df.made_it_count)

#Convert panda data frames into text files
df.to_csv('recipespd.txt',sep='\t')
