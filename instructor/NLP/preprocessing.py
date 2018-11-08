from nltk.tokenize import sent_tokenize
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer

mytext = "Hello Mr. Claspy, how are you? We are doing well."
#Привет, мистер Класпи, как дела? У нас все хорошо.

print(sent_tokenize(mytext))
#print(sent_tokenize(mytext), russian)

stemmer = PorterStemmer()
lemmatizer = WordNetLemmatizer()

print(stemmer.stem('trees'))
print(stemmer.stem('jumping'))
print(stemmer.stem('jokes'))
print(stemmer.stem('purple'))
print(stemmer.stem('dictionary'))

print(stemmer.stem('\n'))
print(lemmatizer.lemmatize('trees'))
print(lemmatizer.lemmatize('jumping'))
print(lemmatizer.lemmatize('jokes'))
print(lemmatizer.lemmatize('purple'))
print(lemmatizer.lemmatize('dictionary'))

# trees
# jumping
# jokes
# purple
