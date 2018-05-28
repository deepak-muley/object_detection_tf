#https://github.com/tensorflow/models/tree/master/research/object_detection
virtualenv venv27
. ./venv27/bin/activate
pip install -r requirements.txt

#Install protoc
mkdir protobuf
pushd protobuf
PROTOC_ZIP=protoc-3.5.1-osx-x86_64.zip
curl -OL https://github.com/google/protobuf/releases/download/v3.5.1/$PROTOC_ZIP
unzip $PROTOC_ZIP
rm -f $PROTOC_ZIP
popd

PROTOC=$(pwd)/protobuf/bin/protoc
$PROTOC --help

#Install tensorflow models
#git clone https://github.com/tensorflow/models.git
wget https://github.com/tensorflow/models/archive/master.zip
unzip master.zip
rm master.zip
mv models-master tf_models
pushd tf_models/research

# From tensorflow/models/research/
$PROTOC object_detection/protos/*.proto --python_out=.

# From tensorflow/models/research/
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim:`pwd`/object_detection

# From tensorflow/models/research/
python object_detection/builders/model_builder_test.py

#Convert, modify object_Detection_tutorial.ipynb to .py file and copy
popd

cp ./object_detection_tutorial_camera.py tf_models/research/object_detection/
pushd tf_models/research/object_detection
python object_detection_tutorial_camera.py 
popd
