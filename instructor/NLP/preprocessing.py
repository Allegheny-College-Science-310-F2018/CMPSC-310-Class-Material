from nltk.tokenize import sent_tokenize 
from nltk.stem import PorterStemmer
from nltk.stem import WordNetLemmatizer 

mytext = "Hello Mr. Claspy, how are you? We are doing well." 
#Привет, мистер Класпи, как дела? У нас все хорошо.

print(sent_tokenize(mytext))
#print(sent_tokenize(mytext), russian)

stemmer = PorterStemmer()
lemmatizer = WordNetLemmatizer() 

