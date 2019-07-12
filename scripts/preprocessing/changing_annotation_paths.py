
# coding: utf-8

import os 
import xml.etree.ElementTree as ET 
import glob
#from natsort import natsorted
DATA_DIR = '/home/yannis/tensorflow/workspace/training_demo/'
PATH_ANNT = os.path.join(DATA_DIR, 'images')
PATH_IMGS = os.path.join(DATA_DIR, 'images')

annt_list = os.listdir(PATH_ANNT)

def fix_annots(annt_list, just_print=False):
    for i, file in enumerate(annt_list):
        tree = ET.parse(os.path.join(PATH_ANNT,file))

        doc = tree.getroot()
        doc.find('folder').text = 'images'
        doc.find('path').text = os.path.join(PATH_IMGS, file[:-4] + '.jpg')
        if just_print:
            print(os.path.join(PATH_IMGS, file[:-4] + '.jpg'))
        else:
            tree.write(os.path.join(PATH_ANNT,file))

fix_annots(annt_list)
