## serverless-pdf-chat-BedRock
This sample application allows you to ask natural language questions of any PDF document you upload. It combines the text generation and analysis capabilities of an LLM with a vector search of the document content. The solution uses serverless services such as Amazon Bedrock to access foundational models, AWS Lambda to run LangChain, and Amazon DynamoDB for conversational memory.

Great! Based on the provided command script, here's a draft README file for your project:

---

## Key features

- Amazon Bedrock for serverless embedding and inference
- LangChain to orchestrate a Q&A LLM chain
- FAISS vector store
- Amazon DynamoDB for serverless conversational memory
- AWS Lambda for serverless compute
- Frontend built in React, TypeScript, TailwindCSS, and Vite.
- Run locally or deploy to AWS Amplify Hosting
- Amazon Cognito for authentication

## Installation Instructions

### Prerequisites

- Python 3.11
- AWS CLI
- SAM CLI
- Git
- Node.js and npm

### Step 1: Install Dependencies

```bash
# Install Python 3.11
sudo dnf install python3.11 -y

# Install pip for Python 3.11
sudo dnf install python3.11-pip -y

# Verify Python 3.11 installation
python3.11 --version

# Uninstall older version of AWS CLI (if exists)
sudo yum remove awscli -y

# Install latest AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Download and install SAM CLI
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install

# configure your AWS CLI profile
aws configure

# Install git
sudo yum install git -y
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/aws-samples/serverless-pdf-chat.git
cd serverless-pdf-chat
```

### Step 3: Configuration

If you want to change the default models or Bedrock Region, edit Bedrock and BedrockEmbeddings in backend/src/generate_response/main.py and backend/src/generate_embeddings/main.py:

```
Bedrock(
   model_id="anthropic.claude-v2", #adjust to use different model
   region_name="us-east-1", #adjust if not using us-east-1
)
```

Edit the following files to customize your configuration:

```bash
sudo vi backend/src/generate_response/main.py
```
```bash
sudo vi backend/src/generate_embeddings/main.py
```
  
If you select models other than the default, you must also adjust the IAM permissions of the GenerateEmbeddingsFunction and GenerateResponseFunction resources in the AWS SAM template:
```bash
sudo vi /backend/template.yaml
```

```
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
```

### Step 4: Backend Setup

```bash
cd backend
sam build
sam deploy --guided
```

### Step 5: Frontend Setup

```bash
cd ../frontend/
sudo touch env.development
echo -e "VITE_REGION=us-east-1\nVITE_API_ENDPOINT=https://abcd1234.execute-api.us-east-1.amazonaws.com/dev/\nVITE_USER_POOL_ID=us-east-1_gxKtRocFs\nVITE_USER_POOL_CLIENT_ID=874ghcej99f8iuo0lgdpbrmi76k" | sudo tee -a env.development

# Install Node.js and npm
sudo yum install nodejs -y

# Install frontend dependencies
npm ci

# Run the application locally. Running this command without the "-- --host 0.0.0.0" will run the app locally on port `http://localhost:5173` but considering you used an EC2 instance to complete this project, you would have to run the below command which will now be accessible on all network interfaces of your EC2 instance, including both `localhost` and the `public IP address` on `http://<Instance_public_IP>:5173/`.(Ensure that your EC2 instance's security group allows inbound traffic on port 5173, and you should be able to access your application from your local machine or any other machine on the internet.)

```bash
npm run dev -- --host 0.0.0.0
```

### Step 6: User Creation

Navigate to the Cognito console and create a user in the user pool you configured in the `env.development` file.

---

Feel free to adjust the content as needed to fit your project's specific requirements. Let me know if you need further assistance or if there's anything else I can help you with!
