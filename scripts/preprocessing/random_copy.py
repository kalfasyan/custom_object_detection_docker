import os
from glob import glob
from random import choices
from natsort import natsorted
from sklearn.model_selection import train_test_split
from shutil import move
import pandas as pd
import numpy as np

inpath = '/opt/yannis/tensorflow/workspace/training_demo/images/'
outpath_train = os.path.join(inpath, 'train')
outpath_test = os.path.join(inpath, 'test')

def absoluteFilePaths(directory, ext='jpg'):
    for dirpath,_,filenames in os.walk(directory):
        for f in filenames:
            if f.endswith(ext):
                yield os.path.abspath(os.path.join(dirpath, f))
            else:
                continue

filelist_jpg = pd.Series(natsorted(list(absoluteFilePaths(inpath, ext='jpg'))))
filelist_xml = pd.Series(natsorted(list(absoluteFilePaths(inpath, ext='xml'))))

inds = np.arange(0,len(filelist_jpg)+len(filelist_xml))
train, test = train_test_split(inds, test_size=0.15, random_state=0, shuffle=True)

S_tr = pd.concat([filelist_jpg.reindex(train), filelist_xml.reindex(train) ]).dropna()
S_te = pd.concat([filelist_jpg.reindex(test), filelist_xml.reindex(test) ]).dropna()

S_tr.apply(lambda x: move(x, outpath_train))
S_te.apply(lambda x: move(x, outpath_test))