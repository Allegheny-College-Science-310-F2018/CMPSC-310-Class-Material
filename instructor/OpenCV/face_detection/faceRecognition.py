# USAGE
# python faceRecognition.py --face cascades/haarcascade_frontalface_default.xml --image images/filename

# import the necessary packages

from __future__ import print_function
from imagesearch.facedetector import faceDetector
import argparse
import cv2


# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-f", "--face", required = True,
	help = "path to where the face cascade resides")
ap.add_argument("-i", "--image", required = True,
	help = "path to where the image file resides")
args = vars(ap.parse_args())


# load the image and convert it to grayscale
image = cv2.imread(args["image"])
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# find faces in the image
fd = faceDetector(args["face"])
# detects the actual faces in the image by making a call to the detect method
faceRects = fd.detect(gray, scaleFactor = 1.1, minNeighbors = 5,
	minSize = (30, 30))
#  prints out the number of faces found in the image
print("I found {} face(s)".format(len(faceRects)))

# loop over the faces and draw a rectangle around each
for (x, y, w, h) in faceRects:
	cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)

# show the detected faces
cv2.imshow("Faces", image)
cv2.waitKey(0)
