# Custom Object Detection in Docker (and Singularity) using Tensorflow's Object Detection API

### Prerequisites
You need docker and nvidia-docker to use this repo. To run it on your system, you obviously need nvidia drivers and cuda.  
I will include commands to run a singularity image later, which is basically converted from the docker one.  
  
### Instructions
1. First go in scripts directory and run `./setup_script.sh`  
This script will define the path where all your training files (e.g. data, configs, label map etc.) will be saved. 
It will make changes to your Dockerfile, main_script and model's config file to change the necessary path names. 
Feel free to change that path to anything you want. If you change it, make sure you change it in the `main_script.sh` as well. 
There, it is used in the `SCRIPTS` variable.  
These directories in a specific structure will be created inside the container and will be used to sync/bind it with the corresponding path inside host (see below).  
  
2. The folder structure should remain as is. The only thing needed is to copy your data (jpgs and xmls) in the 
`detection_files/images/` directory. The dockerfile will take care of splitting the data into train/test according to 
`scripts/random_copy.py` script. For your custom object, make sure to change `label_map.pbtxt` accordingly.  
  
3. Build docker image by running: `nvidia-docker build -t fasterinsects .`  
4. Run it with: `nvidia-docker run -v host_directory/detection_files/:/opt/yannis/detection_files/ fasterinsects`  
  

##### Note: this repo has been tested to train a model on 1 class so far.
##### instructions for running a singularity image (if you work on a cluster) will be included later.
