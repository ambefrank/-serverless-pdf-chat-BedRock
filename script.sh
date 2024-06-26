#Install Python 3.11 by running the command below:

sudo dnf install python3.11 -y

#installing pip using the command below:

sudo dnf install python3.11-pip -y

#To verify Python 3.11 installation:

python3.11 --version

#Uninstall AWS CLI older version

sudo yum remove awscli -y

#Install Latest AWS CLI

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#Download SAM CLI zip file

wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip

#Unzip SAM CLI file

unzip aws-sam-cli-linux-x86_64.zip -d sam-installation

#Install SAM CLI

sudo ./sam-installation/install

#Configure AWS CLI

aws configure

#Install git

sudo yum install git -y

#clone project's repository

git clone https://github.com/aws-samples/serverless-pdf-chat.git

#change dir to serverless-pdf-chat

cd serverless-pdf-chat

#If you want to change the default models or Bedrock Region, edit backend/src/generate_response/main.py and backend/src/generate_embeddings/main.py

sudo vi backend/src/generate_response/main.py
sudo vi backend/src/generate_embeddings/main.py

<<
Bedrock(
   model_id="anthropic.claude-v2", #adjust to use different model
   region_name="us-east-1", #adjust if not using us-east-1
)
>>

#If you select models other than the default, you must also adjust the IAM permissions of the SAM template to use the model versions you choosed.

sudo vi /backend/template.yaml

<<
GenerateResponseFunction:
  Type: AWS::Serverless::Function
  Properties:
    # other properties
    Policies:
      # other policies
      - Statement:
          - Sid: "BedrockScopedAccess"
            Effect: "Allow"
            Action: "bedrock:InvokeModel"
            Resource:
              - "arn:aws:bedrock:*::foundation-model/anthropic.claude-v2" # adjust with different model
              - "arn:aws:bedrock:*::foundation-model/amazon.titan-embed-text-v1" # adjust with different model
>>

#Change to the backend directory and build the application:

cd backend
sam build

#Deploy the application into your AWS account:

sam deploy --guided

-#(Stack Name: serverless-pdf-chat)

##FRONTEND

#Create a file development file in frontend for Vite(cognito credentials)

cd ../frontend/
sudo touch env.development

#Add the following file content and replace the values with the outputs provided by AWS SAM:

echo -e "VITE_REGION=us-east-1\nVITE_API_ENDPOINT=https://sh75mjbfj4.execute-api.us-east-1.amazonaws.com/dev/\nVITE_USER_POOL_ID=us-east-1_ddbRg7E2y\nVITE_USER_POOL_CLIENT_ID=4cegnf0o1ltb4mfluku9sraj8i" | sed '$r /dev/stdin' >> env.development

>>

VITE_REGION=us-east-1
VITE_API_ENDPOINT=https://abcd1234.execute-api.us-east-1.amazonaws.com/dev/
VITE_USER_POOL_ID=us-east-1_gxKtRocFs
VITE_USER_POOL_CLIENT_ID=874ghcej99f8iuo0lgdpbrmi76k

>>

#Install Node.js and npm

sudo yum install nodejs -y

#stay in the Frontend directory and run this command

npm ci

#Run this command in the frontend directory to start the application locally (This will configure Vite to listen on all available network interfaces, making your application accessible externally.)

npm run dev -- --host 0.0.0.0

#Now, navigate to cognito console and create a user in the userpool you created when writing the vite/cognito file.


                       #(Done!  Done!  Done!  Done! Done!)

