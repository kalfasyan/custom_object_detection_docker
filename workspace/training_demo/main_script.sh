echo 'Splitting in Train/Test'
echo 'NOTE: This supposes your data are in workspace/training_demo/images/'
python /home/yannis/tensorflow/scripts/preprocessing/random_copy.py
echo 'Done.'
echo 'Creating csv file for Train'
python /home/yannis/tensorflow/scripts/preprocessing/xml_to_csv.py -i images/train -o annotations/train_labels.csv
echo 'Creating csv file for Test'
python /home/yannis/tensorflow/scripts/preprocessing/xml_to_csv.py -i images/test -o annotations/test_labels.csv
echo 'Csv files created.'
echo 'Creating tfrecord for Train'
python /home/yannis/tensorflow/scripts/preprocessing/generate_tfrecord.py --label=insects --csv_input=annotations/train_labels.csv --output_path=annotations/train.record --img_path=images/train  
echo 'Creating tfrecord for Test'
python /home/yannis/tensorflow/scripts/preprocessing/generate_tfrecord.py --label=insects --csv_input=annotations/test_labels.csv --output_path=annotations/test.record --img_path=images/test
echo 'tfrecord files created.'

echo 'Downloading pre-trained model, extracting, cleaning..'
# FASTER_RCNN_INCEPTION_V2_coco
wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz 
tar xzvf faster_rcnn_inception_v2_coco_2018_01_28.tar.gz -C pre-trained-model/
rm faster_rcnn_inception_v2_coco_2018_01_28.tar.gz

# SSD_MOBILENET_V2_QUANTIZED_300x300_coco
# wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz && \
# tar xzvf ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz -C pre-trained-model/
# rm ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz

echo 'Done.'

python train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/faster_rcnn_inception_v2_coco.config
#ssd_mobilenet_v2_quantized_300x300_coco.config
