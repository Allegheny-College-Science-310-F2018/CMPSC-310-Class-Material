# taken from https://dzone.com/articles/naive-bayes-tutorial-naive-bayes-classifier-in-pyt

from sklearn import datasets

from sklearn import metrics

from sklearn.naive_bayes import GaussianNB

dataset = datasets.load_iris()

model = GaussianNB()

model.fit(dataset.data, dataset.target)

expected = dataset.target

predicted = model.predict(dataset.data)

print(metrics.classification_report(expected, predicted))

print(metrics.confusion_matrix(expected, predicted))
