#!/usr/bin/env python
from ctypes import *
import math
import random
import time
import cv2
import rospy
import numpy as np

from std_msgs.msg import String,Header
from sensor_msgs.msg import Image
from cv_bridge import CvBridge,CvBridgeError
from std_msgs.msg import Float32,Int32,Int32MultiArray
import signal
import sys

#import roslib;roslib.load_manifest('object_detect')
from object_detect.msg import object_detect_result

import os
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

def image_callback(data):
    global cv_image
    global cv_timestr
    global cv_header
    cv_image = CvBridge().imgmsg_to_cv2(data, "bgr8")
    cv_timestr = "%.6f" % data.header.stamp.to_sec()
    cv_header = data.header

def image_callback2(data):
    cv_image = CvBridge().imgmsg_to_cv2(data, "bgr8")
    cv_timestr = "%.6f" % data.header.stamp.to_sec()
    cv_header = data.header

    dynamic_msg = object_detect_result()

    id_object = -1
    dis_x = -1
    dis_y = -1
    #detect&classify
    dynamic_object = []
    start = time.clock()
    frame = cv_image
    cv2.imwrite("temp.jpg",frame)
    im_path = b"temp.jpg"
    im = frame
    r = detect(detect_net, detect_meta, im_path)
    for bbox in r:
        rec = (max(0,int(bbox[2][0])-int(bbox[2][2]/2)),max(0,int(bbox[2][1])-int(bbox[2][3]/2)),max(0,int(bbox[2][0])+int(bbox[2][2]/2)),max(0,int(bbox[2][1])+int(bbox[2][3]/2)))
        dynamic_object.append((id_object,int(classes.index(bbox[0])),rec[0],rec[1],rec[2],rec[3],dis_x,dis_y))

    dynamic_msg.header = cv_header
    dynamic_msg.header.frame_id = "dynamic_object_detector_result"
    end = time.clock()
    print("total_time:"+str(end-start))
    print(dynamic_object)
    print(cv_timestr)
    dynamic_msg.result.data = np.array(dynamic_object).flatten().tolist()
    print("publish topic header : ")
    print(dynamic_msg.header)
    print("publish topic data : ")
    print(dynamic_msg.result.data)
    dynamic_object_pub.publish(dynamic_msg)

def sample(probs):
    s = sum(probs)
    probs = [a/s for a in probs]
    r = random.uniform(0, 1)
    for i in range(len(probs)):
        r = r - probs[i]
        if r <= 0:
            return i
    return len(probs)-1

def c_array(ctype, values):
    arr = (ctype*len(values))()
    arr[:] = values
    return arr

class BOX(Structure):
    _fields_ = [("x", c_float),
                ("y", c_float),
                ("w", c_float),
                ("h", c_float)]

class DETECTION(Structure):
    _fields_ = [("bbox", BOX),
                ("classes", c_int),
                ("prob", POINTER(c_float)),
                ("mask", POINTER(c_float)),
                ("objectness", c_float),
                ("sort_class", c_int)]

class IMAGE(Structure):
    _fields_ = [("w", c_int),
                ("h", c_int),
                ("c", c_int),
                ("data", POINTER(c_float))]

class METADATA(Structure):
    _fields_ = [("classes", c_int),
                ("names", POINTER(c_char_p))] 

#lib = CDLL("/home/pjreddie/documents/darknet/libdarknet.so", RTLD_GLOBAL)
lib = CDLL("/home/nvidia/darknet/libdarknet.so", RTLD_GLOBAL)
lib.network_width.argtypes = [c_void_p]
lib.network_width.restype = c_int
lib.network_height.argtypes = [c_void_p]
lib.network_height.restype = c_int

predict = lib.network_predict
predict.argtypes = [c_void_p, POINTER(c_float)]
predict.restype = POINTER(c_float)

set_gpu = lib.cuda_set_device
set_gpu.argtypes = [c_int]

make_image = lib.make_image
make_image.argtypes = [c_int, c_int, c_int]
make_image.restype = IMAGE

get_network_boxes = lib.get_network_boxes
get_network_boxes.argtypes = [c_void_p, c_int, c_int, c_float, c_float, POINTER(c_int), c_int, POINTER(c_int)]
get_network_boxes.restype = POINTER(DETECTION)

make_network_boxes = lib.make_network_boxes
make_network_boxes.argtypes = [c_void_p]
make_network_boxes.restype = POINTER(DETECTION)

free_detections = lib.free_detections
free_detections.argtypes = [POINTER(DETECTION), c_int]

free_ptrs = lib.free_ptrs
free_ptrs.argtypes = [POINTER(c_void_p), c_int]

network_predict = lib.network_predict
network_predict.argtypes = [c_void_p, POINTER(c_float)]

reset_rnn = lib.reset_rnn
reset_rnn.argtypes = [c_void_p]

load_net = lib.load_network
load_net.argtypes = [c_char_p, c_char_p, c_int]
load_net.restype = c_void_p

do_nms_obj = lib.do_nms_obj
do_nms_obj.argtypes = [POINTER(DETECTION), c_int, c_int, c_float]

do_nms_sort = lib.do_nms_sort
do_nms_sort.argtypes = [POINTER(DETECTION), c_int, c_int, c_float]

free_image = lib.free_image
free_image.argtypes = [IMAGE]

letterbox_image = lib.letterbox_image
letterbox_image.argtypes = [IMAGE, c_int, c_int]
letterbox_image.restype = IMAGE

load_meta = lib.get_metadata
lib.get_metadata.argtypes = [c_char_p]
lib.get_metadata.restype = METADATA

load_image = lib.load_image_color
load_image.argtypes = [c_char_p, c_int, c_int]
load_image.restype = IMAGE

rgbgr_image = lib.rgbgr_image
rgbgr_image.argtypes = [IMAGE]

predict_image = lib.network_predict_image
predict_image.argtypes = [c_void_p, IMAGE]
predict_image.restype = POINTER(c_float)

def classify(net, meta, im):
    out = predict_image(net, im)
    res = []
    for i in range(meta.classes):
        res.append((meta.names[i], out[i]))
    res = sorted(res, key=lambda x: -x[1])
    return res

def detect(net, meta, image, thresh=.5, hier_thresh=.5, nms=.45):
    im = load_image(image, 0, 0)
    num = c_int(0)
    pnum = pointer(num)
    predict_image(net, im)
    dets = get_network_boxes(net, im.w, im.h, thresh, hier_thresh, None, 0, pnum)
    num = pnum[0]
    if (nms): do_nms_obj(dets, num, meta.classes, nms);

    res = []
    for j in range(num):
        for i in range(meta.classes):
            if dets[j].prob[i] > 0.7:
                b = dets[j].bbox
                res.append((meta.names[i], dets[j].prob[i], (b.x, b.y, b.w, b.h)))
    res = sorted(res, key=lambda x: -x[1])
    free_image(im)
    free_detections(dets, num)
    return res
    
if __name__ == "__main__":

    #init
    global cv_image,cv_timestr,cv_header
    cv_header = Header()
    cv_image = np.zeros((960,604,3),np.uint8)
    cv_timestr = "%.6f" % 0

    global classes
    classes = ["car_T","car_NT","bus_T","bus_NT","person_T","person_NT","bike_T","bike_NT","truck_T","truck_NT","motor_T","motor_NT"]
    
    #load_detect_net
    detect_net = load_net(b"YOLOV3_85_test.cfg", b"YOLOV3_85_370000.weights", 0)
    detect_meta = load_meta(b"BDD12_detector.data")

    #publish result
    global dynamic_object_pub
    dynamic_object_pub = rospy.Publisher("/dynamic_object_detect",object_detect_result,queue_size = 1)
    
    #subscrib image
    rospy.init_node('dynamic',anonymous=True)
    image_sub = rospy.Subscriber("/image_raw",Image,image_callback2,queue_size = 1,buff_size = 52428800)

    while not rospy.is_shutdown():
        continue










        


