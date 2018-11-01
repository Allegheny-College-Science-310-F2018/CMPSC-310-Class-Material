# USAGE
# python Detectmultiscale.py --image images/filename

# import the necessary packages
from __future__ import print_function
import argparse
import datetime
import imutils
import cv2

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required=True,
	help="path to the input image")
# the step size in the x and y direction of our sliding window
ap.add_argument("-w", "--win-stride", type=str, default="(8, 8)",
	help="window stride")
# switch controls the amount of pixels the ROI is padded with prior to HOG feature vector extraction and SVM classification
ap.add_argument("-p", "--padding", type=str, default="(16, 16)",
	help="object padding")
# control the scale of the image pyramid (allowing us to detect people in images at multiple scales)
ap.add_argument("-s", "--scale", type=float, default=1.05,
	help="image pyramid scale")
# apply if want to apply mean-shift grouping to the detected bounding boxes ( to combine multiple boxes around the same object into one)
ap.add_argument("-m", "--mean-shift", type=int, default=-1,
	help="whether or not mean shift grouping should be used")
args = vars(ap.parse_args())

# evaluate the command line arguments (using the eval function like
# this is not good practice, but let's tolerate it for the example - it allows us to easily use different --win-stride and --pading values)
# eval interprets a string as code - bad!
winStride = eval(args["win_stride"])
padding = eval(args["padding"])
meanShift = True if args["mean_shift"] > 0 else False

# initialize the HOG descriptor/person detector
# First, initialize the Histogram of Oriented Gradients descriptor
hog = cv2.HOGDescriptor()
# Then, set the Support Vector Machine to be pre-trained pedestrian detector
hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())

# load the image and resize it
# the smaller our image is, the faster it will be to process and detect people in it
image = cv2.imread(args["image"])
image = imutils.resize(image, width=min(400, image.shape[1]))

# detect people in the image
start = datetime.datetime.now()
# detectMultiScale  method constructs an image pyramid with --scale  and a sliding window step size of --winStride  pixels in both the x and y direction, respectively
'''An image pyramid is a multi-scale representation of an image: 
At each layer of the image pyramid the image is downsized and (optionally) smoothed via a Gaussian filter.

 At each stop of the sliding window (and for each level of the image pyramid, discussed in the scale  section below), we (1) extract HOG features and (2) pass these features on to our Linear SVM for classification. The process of feature extraction and classifier decision is an expensive one, so we would prefer to evaluate as little windows as possible if our intention is to run our Python script in near real-time.'''
 
 # Typical values for scale  are normally in the range [1.01, 1.5]. If you intend on running detectMultiScale  in real-time, this value should be as large as possible without significantly sacrificing detection accuracy.
(rects, weights) = hog.detectMultiScale(image, winStride=winStride,
	padding=padding, scale=args["scale"], useMeanshiftGrouping=meanShift)
print("[INFO] detection took: {}s".format(
	(datetime.datetime.now() - start).total_seconds()))

# draw the original bounding boxes
for (x, y, w, h) in rects:
	cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)

# show the output image
cv2.imshow("Detections", image)
cv2.waitKey(0)
