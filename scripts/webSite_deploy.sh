#STANDAR VARIABLES
SOURCE="$(pwd)/templates"
AWS_DEFAULT_REGION=us-east-1
BUCKET="template1bucket"
UUID=$$
STACK="Ballastlane-challenge"
DOMAIN="technicaltest.com"
ZONEID="Z3AQBSTGFYJSTF"

export AWS_PROFILE=dev


sam package --template-file "$SOURCE/template1.yml" --output-template-file "template1_$UUID.yml" --s3-bucket $BUCKET --region $AWS_DEFAULT_REGION
sam deploy  --template-file "template1_$UUID.yml" --stack-name $STACK --region $AWS_DEFAULT_REGION --capabilities CAPABILITY_NAMED_IAM --parameter-overrides UUID=$UUID Domain=$DOMAIN ZoneId=$ZONEID
rm "$(pwd)/template1_$UUID.yaml"


