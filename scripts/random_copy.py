import os
from glob import glob
from random import choices
from natsort import natsorted
from sklearn.model_selection import train_test_split
from shutil import move
import pandas as pd
import numpy as np
import argparse

# Initiate argument parser
parser = argparse.ArgumentParser(
    description="Splitting into train and test")
parser.add_argument("-i",
                    "--inputDir",
                    help="Path to the folder where the input images and annotations are stored",
                    type=str)
parser.add_argument("-s",
                    "--splitPct",
                    help="Path to the folder where the input images and annotations are stored",
                    type=float)                    
args = parser.parse_args()

inpath = args.inputDir
outpath_train = os.path.join(inpath, 'train')
outpath_test = os.path.join(inpath, 'test')

if not os.path.exists(outpath_train):
    os.makedirs(outpath_train)
if not os.path.exists(outpath_test):
    os.makedirs(outpath_test)

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
train, test = train_test_split(inds, test_size=args.splitPct, random_state=0, shuffle=True)

S_tr = pd.concat([filelist_jpg.reindex(train), filelist_xml.reindex(train) ]).dropna()
S_te = pd.concat([filelist_jpg.reindex(test), filelist_xml.reindex(test) ]).dropna()

S_tr.apply(lambda x: move(x, outpath_train))
S_te.apply(lambda x: move(x, outpath_test))