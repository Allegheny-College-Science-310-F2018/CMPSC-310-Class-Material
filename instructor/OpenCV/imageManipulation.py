# Usage:
# python imageManipulation.py --image trex.png

from __future__ import print_function
import argparse
import cv2

# construct argument parser and parse arguments
ap = argparse.ArgumentParser()
ap.add_argument("--image", "-i", required = True,
                help = "Path to the image")
args = vars(ap.parse_args())

# load an image and display some print_function
image = cv2.imread(args["image"])
print("height: {} pixels".format(image.shape[0]))
print("width: {} pixels".format(image.shape[1]))
print("channels: {} pixels".format(image.shape[2]))

cv2.imshow("Original Image", image)
cv2.waitKey(0)

cv2.imwrite("trex1.jpg", image)

(b, g, r) = image[0,0]
print("Pixel at (0,0) Red: {}, Green: {}, Blue: {} ".format
        (r,g,b))

image[0,0] = (0,0,255)
(b, g, r) = image[0,0]
cv2.imshow("Changed pixel", image)
cv2.waitKey(0)
print("Pixel at (0,0) Red: {}, Green: {}, Blue: {} ".format
        (r,g,b))

corner = image[0:100, 0:100]
cv2.imshow("Corner", corner)
image[0:100, 0:100] = (0, 255, 0)
cv2.imshow("Updated image", image)
cv2.waitKey(0)
