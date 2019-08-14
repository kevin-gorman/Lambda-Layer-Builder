# Lambda Layer Creator
This is a simple package for assisting with making AWS Lambda layers. It requires AWSCLI and zip. You also need to configure your AWS credentials as described here https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html. It is designed for packages in the pip directory, but it can be used for others with additional configuration.

### Example usage
##### Example 1: Pip Installed Package
I used this to upload AWSCLI to my Lambda function:

*Step 1.* Install the package and its dependancies to the 'files' directory
```
cd files
# The '-I' flag ignores previous installations of the package and its dependancies
# The '--prefix' flag tells it to install it to a prefix configuration in a certain directory
pip install --prefix . -I
```
For this package, it creates the follwing tree
```
files
└── bin
│   │ (executables)
│
└── lib 
│   └── python2.7
│   │   └── dist-packages
│   │   │   │ (libraries)
│
└── lib64
│   └── python2.7
│   │   └── dist-packages
│   │   │   │ (libraries)
```
It creates a directory 'bin' that holds its executables and 'lib' and 'lib64' that hold its libraries. You can repeat this for multiple packages, and they will continue to add to these directories. To configure it locally, you would set:
```
export PYTHONPATH=\path\to\lambda-layer-creator\files\lib\python2.7\dist-packages
```
so it can find its own libraries, but this configuration is not communicated to the lambda layer, so my solution was to do this:
```
cp -r bin\* . 
cp -r lib\python2.7\dist-packages\* .
cp -r lib64\python2.7\dist-packages\* .
```
This puts everything in the same directory so everything can find everything else.

*Step 2.* Package the packages
```
cd .. 
make build
```
This zips the contents of 'files' into 'layer\layer.zip' which is the format that AWS Lambda likes.

*Step 3.* Publish the layer
```
make publish
```
This executes 'publish.sh' that publishes the layer to your lambda account. You can edit this file to set your publishing preferences. Your layer will be uploaded to your AWS account and the arn for it should be outputted. The executables can then be called from your lambda functions as if they were installed regularly.



##### Example 2: Installing Library
To install a library of your own, all you need to do is move the file to the 'files' directory, then deploy it with steps 2 and 3 above.
```
lambda-layer-creator
│   README.md
│   Makefile    
│   publish.sh
└── files
│   │ my_library.py
```
It can then be imported like a normal library.
```
import my_library as ml
```
