sed -i 's+PATH_TO_BE_CONFIGURED+/opt/yannis/detection_files/+g' ../Dockerfile
sed -i 's+PATH_TO_BE_CONFIGURED+/opt/yannis/detection_files/+g' main_script.sh
sed -i 's+PATH_TO_BE_CONFIGURED+/opt/yannis/detection_files+g' ../detection_files/training/faster_rcnn_inception_v2_coco.config
