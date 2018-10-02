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

# load the image and resize it
# the smaller our image is, the faster it will be to process and detect people in it
image = cv2.imread(args["image"])
image = imutils.resize(image, width=min(400, image.shape[1]))

# show the output image
cv2.imshow("Detections", image)
cv2.waitKey(0)
