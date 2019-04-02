import boto3
import botocore

s3 = boto3.client('s3')
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    bucket_name = 'mh-pubkey'
    key = 'mh.pub'
    key_name = 'mh'

    try:
        response = s3.get_object(Bucket=bucket_name, Key=key)
        s3_key = response['Body'].read()
        
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            print("The S3 object does not exist.")
        else:
            raise
    
    if not s3_key:
        ec2.import_key_pair(KeyName=key_name, PublicKeyMaterial=s3_key)
