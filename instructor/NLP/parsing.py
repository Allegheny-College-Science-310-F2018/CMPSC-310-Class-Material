from bs4 import BeautifulSoup

import urllib.request

import nltk

from nltk.corpus import stopwords

#crawl the webpage
response = urllib.request.urlopen('https://www.cs.allegheny.edu')

html = response.read()

# clean by stripping html tags
soup = BeautifulSoup(html,"html5lib")
text = soup.get_text(strip=True)

# tokenize (split by whitespace)
tokens = [t for t in text.split()]

# make a copy of the list
clean_tokens = tokens[:]

# get english stop words from nltk
sr = stopwords.words('english')

# iterate through the tokens and remove stop words
for token in tokens:
    if token in sr:
        clean_tokens.remove(token)

# calculate the frequency distribution
freq = nltk.FreqDist(clean_tokens)
print(freq.most_common())

# The items() method returns a view object that displays
# a list of a given dictionary's (key, value) tuple pair
for key,val in freq.items():
    print (str(key) + ':' + str(val) + '\n')

freq.plot(20,cumulative=False)
