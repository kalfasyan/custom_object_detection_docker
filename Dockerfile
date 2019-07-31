#FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

ENV TZ=Europe/Brussels
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common
RUN add-apt-repository ppa:jonathonf/python-3.6

RUN apt-get update && apt-get install -y --no-install-recommends \
	apt-utils \
    build-essential \
    python3.6 \    
    python3.6-dev \
    python3-pip \
    python3.6-venv \
	wget \
    curl \
    pkg-config \
    rsync \
	nano \
	git \
	protobuf-compiler \
    python3-setuptools \
	python3-tk \
    software-properties-common \
    unzip \
    && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2
RUN update-alternatives --config python

# Upgrading pip
RUN python -m pip install pip --upgrade && \
    python -m pip install wheel

# Upgrading pip (different way)
#RUN curl https://bootstrap.pypa.io/get-pip.py | python3

# Install object detection api dependencies that are also needed for pycocoapi
RUN apt-get install -y protobuf-compiler && \
    pip install Cython && \
    pip install matplotlib==3.0.2 && \
    pip install contextlib2 

# Clone tensorflow models repo and moving it to custom dir
RUN mkdir -p /opt/yannis/tensorflow/ && \
    git clone --depth 1 https://github.com/tensorflow/models.git && \
    mv models/ /opt/yannis/tensorflow/models

# Install pycocoapi
RUN git clone --depth 1 https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make -j8 && \
    cp -r pycocotools /opt/yannis/tensorflow/models/research && \
    cd ../../ && \
    rm -rf cocoapi

# Get protoc 3.0.0, rather than the old version already in the container
RUN curl -OL "https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip" && \
    unzip protoc-3.0.0-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin && \
    mv proto3/include/* /usr/local/include && \
    rm -rf proto3 protoc-3.0.0-linux-x86_64.zip

# Run protoc on the object detection repo
RUN cd /opt/yannis/tensorflow/models/research && \
    protoc object_detection/protos/*.proto --python_out=.

# Set the PYTHONPATH to finish installing the API
ENV PYTHONPATH $PYTHONPATH:/opt/yannis/tensorflow/models/research:/opt/yannis/tensorflow/models/research/slim

# Installing dependencies for machine learning
RUN  pip install natsort && \
	pip install lxml==4.3.1 && \
	pip install pillow==5.4.1 && \
	pip install opencv-python==3.4.2.17 && \
	pip install jupyter==1.0.0 && \
	pip install scikit-image==0.14.2 && \
	pip install scikit-learn==0.20.2 && \
	pip install pandas==0.23.4 && \
        pip install tensorflow-gpu==1.12.3

# Switching working directory and copying all local files
WORKDIR /opt/yannis/tensorflow/
COPY . .

# Creating folder structure according to tensorflow's object detection api tutorial
RUN mkdir -p workspace/training_demo/annotations && \
    mkdir -p workspace/training_demo/images/test && \
    mkdir -p workspace/training_demo/images/train && \
    mkdir -p workspace/training_demo/pre-trained-model && \
    mkdir -p workspace/training_demo/training && \
    mv custom_data/images_and_annotations/* workspace/training_demo/images/

EXPOSE 8008

WORKDIR /opt/yannis/tensorflow/workspace/training_demo/

ENTRYPOINT bash main_script.sh
