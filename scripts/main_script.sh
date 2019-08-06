HOST_FILES=PATH_TO_BE_CONFIGURED
SCRIPTS=/opt/yannis/tensorflow/scripts

echo 'Splitting in Train/Test'
python $SCRIPTS/random_copy.py -i $HOST_FILES/images/ -s 0.15
echo 'Done.'

echo 'Downloading pre-trained model, extracting, cleaning..'
# FASTER_RCNN_INCEPTION_V2_coco
wget -P $HOST_FILES/pre-trained-model/ http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz 
tar xzvf $HOST_FILES/pre-trained-model/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz -C $HOST_FILES/pre-trained-model/
rm $HOST_FILES/pre-trained-model/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
echo 'Done.'

# CSVs
echo 'Creating csv file for Train'
python $SCRIPTS/xml_to_csv.py \
    -i $HOST_FILES/images/train \
    -o $HOST_FILES/annotations/train_labels.csv
echo 'Creating csv file for Test'
python $SCRIPTS/xml_to_csv.py \
    -i $HOST_FILES/images/test \
    -o $HOST_FILES/annotations/test_labels.csv
echo 'Csv files created.'

# TFRECORDS
echo 'Creating tfrecord for Train'
python $SCRIPTS/generate_tfrecord.py \
    --label=insects \
    --csv_input=$HOST_FILES/annotations/train_labels.csv \
    --output_path=$HOST_FILES/annotations/train.record \
    --img_path=$HOST_FILES/images/train  
echo 'Creating tfrecord for Test'
python $SCRIPTS/generate_tfrecord.py \
    --label=insects \
    --csv_input=$HOST_FILES/annotations/test_labels.csv \
    --output_path=$HOST_FILES/annotations/test.record \
    --img_path=$HOST_FILES/images/test
echo 'tfrecord files created.'
echo 'Done.'

python $SCRIPTS/train.py --logtostderr \
    --train_dir=$HOST_FILES/training/ \
    --pipeline_config_path=$HOST_FILES/training/faster_rcnn_inception_v2_coco.config
#ssd_mobilenet_v2_quantized_300x300_coco.config
