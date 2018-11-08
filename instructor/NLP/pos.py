from nltk.corpus import twitter_samples
from nltk.tag import pos_tag_sents

# Load tokenized data of tweets
tokens = twitter_samples.tokenized('positive_tweets.json')

# tag tokens
tagged_tokens = pos_tag_sents(tokens)

# print output of the couple of tagged tokens

## count nouns
noun_count = 0
adj_count = 0

for tweet in tagged_tokens:
    for pair in tweet:
        tag = pair[1]
        if tag == 'NN':
            noun_count += 1

print('Number of nouns: ', noun_count)
