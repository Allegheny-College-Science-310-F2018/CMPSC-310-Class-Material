import nltk
from nltk.tokenize import word_tokenize
  
# training data
trainingdata = [("Great place to be when you are in Meadville.", "pos"),
  ("The place was being remodeled when I visited so the seating was limited.", "neg"),
  ("Loved the atmosphere, loved the food", "pos"),
  ("The food is delicious but not over the top.", "neg"),
  ("Service - Little slow, probably because too many people.", "neg"),
  ("The place is not easy to get to", "neg"),
  ("Chicken curry was too spicy", "pos"),
]
  
# Step 2 
# TODO: add comment to explain this step
# note more info on nltk's tokenization can be found at: https://www.nltk.org/api/nltk.tokenize.html
dictionary = set(word.lower() for passage in trainingdata for word in word_tokenize(passage[0]))
#print(dictionary)
  
# Step 3
# TODO: add comment to explain this step
t = [({word: (word in word_tokenize(x[0])) for word in dictionary}, x[1]) for x in trainingdata]
  
# Step 4 – the classifier is trained with sample data
# Bayes Algorithm is used
classifier = nltk.NaiveBayesClassifier.train(t)
  
test_data = "Fried rice was spicy"
test_data_features = {word.lower(): (word in word_tokenize(test_data.lower())) for word in dictionary}
  
print (classifier.classify(test_data_features))
