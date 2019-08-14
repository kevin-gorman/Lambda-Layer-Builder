#!/bin/bash -e

region="us-east-1"

LAYER_NAME="lambda-layer"

echo "Publishing layer to $region..."

LAYER_ARN=$(aws lambda publish-layer-version --region $region --layer-name $LAYER_NAME --zip-file fileb://layer/layer.zip | jq -r .LayerVersionArn)

#Makes the layer publicly accessable. Comment out if you don't want that.
POLICY=$(aws lambda add-layer-version-permission --region $region --layer-name $LAYER_NAME --version-number $(echo -n $LAYER_ARN | tail -c 1) --statement-id $LAYER_NAME --action lambda:GetLayerVersion --principal \*)
    
echo $LAYER_ARN
echo "$region complete"
echo ""
 