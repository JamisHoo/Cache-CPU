#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# $File: img2code.py
# $Date: Sat Dec 21 17:41:54 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

import cv2
import sys
import math

def iround(x):
    return int(math.floor(x + 0.5))

def img2code(img, var_name):
    assert img.shape == (15, 15, 3), img.shape

    print "static const unsigned char {}[{}] = {{".format(
        var_name, img.shape[0] * img.shape[1]), 

    f1 = 7.0 / 255
    f2 = 3.0 / 255
    array = []
    for row in img:
        for pxl in row:
            b, g, r = pxl
            r = iround(r * f1)
            g = iround(g * f1)
            b = iround(b * f2)
            array.append(str((r << 5) | (g << 2) | b))

    print ' ,'.join(array),
    print '};'


if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit('usage: {} <image> <var name>'.format(sys.argv[0]))

    img = cv2.imread(sys.argv[1], cv2.CV_LOAD_IMAGE_COLOR)
    img2code(img, sys.argv[2])

