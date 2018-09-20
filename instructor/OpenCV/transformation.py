# USAGE
# python transformation.py --image ../images/trex.png

# Import the necessary packages
import numpy as np
import argparse
import imutils
import cv2

# Construct the argument parser and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True,
	help = "Path to the image")
args = vars(ap.parse_args())

# Load the image and show it
image = cv2.imread(args["image"])
cv2.imshow("Original", image)

# translation matrix
M = np.float32([[1, 0, 25], [0, 1, 50]])
shifted = cv2.warpAffine(image, M, (image.shape[1], image.shape[0]))
cv2.imshow("Shifted", shifted)
cv2.waitKey(0)

shifted = imutils.translate(image, 0, 100)
cv2.imshow("Shifted Down", shifted)
cv2.waitKey(0)

# rotate an images
rotated = imutils.rotate(image, 180)
cv2.imshow("Rotated", rotated)
cv2.waitKey(0)

#cv2.destroyWindow("Original")
cv2.destroyAllWindows()

resized = imutils.resize(image, width = 100)
cv2.imshow("Resized", resized)
cv2.waitKey(0)

# 0 - vertically, 1 - horiz, -1 - both
flipped = cv2.flip(image, 1)
cv2.imshow("Flipped", flipped)
cv2.waitKey(0)

# cropping
cropped = image[30:120, 240:335]
cv2.imshow("Cropped", cropped)
cv2.waitKey(0)
