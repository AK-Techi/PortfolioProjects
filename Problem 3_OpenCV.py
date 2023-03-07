#!/usr/bin/env python
# coding: utf-8

# In[61]:


import cv2
#import pandas as pd
#import numpy as np
import os


# In[62]:


vid = cv2.VideoCapture("C:\\Users\\kumar\\pyproj\\video.avi")


# In[63]:


vid.get(cv2.CAP_PROP_FRAME_COUNT)


# In[64]:


vid.get(cv2.CAP_PROP_FPS)


# In[65]:


1796/29.0


# In[66]:


29*30


# In[67]:


29*35


# In[68]:


#main code
currentframe = 0
if not os.path.exists('data'):
    os.makedirs('data')
    
while (True):
    
    ret, frame = vid.read()
    if ret == False:
        break
    #cv2.imshow("Output", frame)
    cv2.imwrite('./data' + '/frame' + str(currentframe) + '.png', frame)
    currentframe +=1


# In[73]:


from os.path import isfile, join

def convert_frames_to_video(pathIn,pathOut,fps):
    frame_array = []
    files = [f for f in os.listdir(pathIn) if isfile(join(pathIn, f))]

    #for sorting the file names properly
    files.sort(key = lambda x: int(x[5:-4]))

    for i in range(870,1016):
        filename=pathIn + files[i]
        #reading each files
        img = cv2.imread(filename)
        
        height, width, layers = img.shape
        size = (width,height)
        
        cv2.rectangle(img, (910, 590), (1100, 490), (0, 0, 255), -1)
        #print(filename)
        #inserting the frames into an image array
        frame_array.append(img)

    out = cv2.VideoWriter(pathOut,cv2.VideoWriter_fourcc(*'DIVX'), fps, size)
    
    for i in range(len(frame_array)):
        # writing to a image array
        out.write(frame_array[i])
        #print(out.get(cv2.CAP_PROP_FRAME_COUNT))
    out.release()
    cv2.destroyAllWindows()

def main():
    pathIn= './data/'
    pathOut = 'output.avi'
    fps = 29.0
    convert_frames_to_video(pathIn, pathOut, fps)

if __name__=="__main__":
    main()

