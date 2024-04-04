<a href="https://github.com/savedra1/websit/actions"><img src="https://github.com/charmbracelet/bubbletea/workflows/build/badge.svg" alt="Build Status"></a> ![GitHub last commit](https://img.shields.io/github/last-commit/savedra1/website)


# About

This static website is hosted in AWS S3 and routed via AWS Cloudfront and Route53 to serve a custom domain with SSL validation. All AWS infrastructure involved is managed using Terraform. Continuous integration and deployment is enabled with GitHub Actions and the Google Cloud API is used in the CICD pipeline for building my professional CV as a PDF from a Google Doc. The PDF is also separately hosted in another S3 bucket with its own Cloudfront distribution. 

### Deployment pipeline

<p align="center">

  <img src="./assets/diagram.png?raw=true" />

</p>

With this workflow, any changes I push to the project's GitHub repository can be deployed automatically, updating the content displayed in both publicly hosted sites within seconds. The only cost incurred from this architecture was the purchasing of my custom domain and $0.50 per month charge for my 'Hosted Zone' in Route53.  

## Build inputs

> AWS
- __AWS_REGION__: The region for my public S3 buckets
- __CV_BUCKET__: The name of the bucket used to host my professional CV
- __CV_STATE_BUCKET__: The name of the state bucket used to manage my CV infrastructure
- __DOMAIN_NAME__: The name of my custom domain
- __SITE_BUCKET__: The name of the bucket used to host my website
- __STATE_BUCKET__: The name of the bucket used to manage the state information for my website's infrastructure 
- __STATE_FILE__: The path for the state file to use in each state bucket 

> GCP
- __GOOGLE_DOC_ID__
- __GCP_CLIENT_CERT__
- __GCP_CLIENT_EMAIL__
- __GCP_CLIENT_ID__
- __GCP_PRIVATE_KEY_ID__
- __GCP_PROJECT_ID__
- __GCP_SECRET_KEY__

## Build outputs 

- __CV_DOMAIN__: The Cloudfront-generated web address where my CV is accessible

## Deploy this for yourself

_Before getting started, you will need the following..._

- AWS CLI credentials with permissions to the following resources:
  - s3
  - Cloudfront
  - ACM
  - Route53

- The `terraform` CLI must be available in the environment you plan to use.

- A custom domain that is managed within AWS Route53. If your domain is currently configured somewhere else, see [this guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-transfer-to-route-53.html) for getting it transferred. 

- Google Cloud service account user credentials with the following permission scopes:
  - `https://www.googleapis.com/auth/docs`
  - `https://www.googleapis.com/auth/drive`
  See [this guide](https://cloud.google.com/iam/docs/service-accounts-create) for getting this set up and remember to activate the Drive/Docs APIs for the related GCP project. 


### 1. Stage

Create the state buckets in AWS S3 that will be used to manage the `terraform` deployments. I would advise  naming the state buckets with the same convention used for your site buckets. E.g. if your site is going to be named `example.com`, name your state bucket something like `example.com-state`.   

Clone this repo with `git clone https://github.com/savedra1/website.git` and add your variable inputs to the environment. For example:

```shell
git clone https://github.com/savedra1/website.git

cd website

export AWS_ACCESS_KEY="your_aws_user_access_key_value"
export AWS_SECRET_KEY="your_aws_user_secret_key_value"
export AWS_REGION="us-west-2"
export CV_BUCKET="my-cv-bucket"
export CV_STATE_BUCKET="cv-state-bucket"
export DOMAIN_NAME="example.com"
export SITE_BUCKET="my-site-bucket"
export STATE_BUCKET="state-bucket"
export STATE_FILE="/path/to/statefile"
export CV_DOMAIN="examp.le"
export GOOGLE_DOC_ID="fake_google_doc_id"
export GCP_CLIENT_CERT="fake_client_cert"
export GCP_CLIENT_EMAIL="fake_client_email@example.com"
export GCP_CLIENT_ID="fake_client_id"
export GCP_PRIVATE_KEY_ID="fake_private_key_id"
export GCP_PROJECT_ID="fake_project_id"
export GCP_SECRET_KEY="fake_secret_key"

```

If running from somewhere like GitHub Actions instead, simply add these inputs as environment secrets instead.

### 2. Build

Add the contents of your CV to your Google Doc and remember to add view permissions for the GCP service account user. Replace the contents of the `/website/website/` directory with your own code, making sure you at least have a file named `index.html` and a file called `error.html`. 

### 3. Deploy

Now that your inputs are available in your environment you can deploy your infrastructure with the following commands...

```shell
terraform init # initialise your terraform backend

terraform plan # inspect the planned changes

terraform apply # apply your changes (this command will output the endpoint for your publicly-hosted CV PDF to the console)
```

If running from a cloud environment like GitHub Actions it would be best to initialise your `terraform` backend in way that explicitly states which bucket to use, avoiding the need for a local state file

```shell
terraform init -backend-config="bucket=${{ secrets.STATE_BUCKET }}"
```

Here's one of my GitHub Actions workflows for inspiration

```shell
name: Terraform plan on PR (website only)
on:
  pull_request: # Only run this when a PR is created and any of the commits contain changes to the website code
    branches:
      - main
    paths:
      - website/*
      - website-infra/*
jobs:
  terraform-plan:
    runs-on: ubuntu-latest
    env: # add inputs to the environment
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_KEY }}
      TF_VAR_S3_STATE_BUCKET: ${{ secrets.STATE_BUCKET }}
      TF_VAR_STATE_FILE: ${{ secrets.STATE_FILE }}
      TF_VAR_SITE_BUCKET: ${{ secrets.SITE_BUCKET }}
      TF_VAR_AWS_REGION: ${{ secrets.AWS_REGION }}
      TF_VAR_DOMAIN_NAME: ${{ secrets.DOMAIN_NAME }}
      TF_IN_AUTOMATION: "True"
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2 

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Run terraform plan
        id: plan
        run: |
          cd website-infra
          terraform init -backend-config="bucket=${{ secrets.STATE_BUCKET }}"
          echo 'plan<<EOF' >> $GITHUB_OUTPUT
          terraform plan -no-color -out=tfplan >> $GITHUB_OUTPUT # run terraform plan and save the output to the environment 
          echo 'EOF' >> $GITHUB_OUTPUT
      
      - name: Comment Plan # This requires repo's actions permissions to be updated to allow write token permissions
        id: comment-plan
        uses: peter-evans/create-or-update-comment@v4 # Comments the output from terraform plan to the pull request
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          issue-number: ${{ github.event.pull_request.number }}
          body: |
            __website-infra plan__:
            ```shell
            ${{ steps.plan.outputs.plan }}
            ```
            Merge this PR to apply these changes.
```

### 4. Test

After you have successfully deployed your sites, allow roughly 20 minutes for all DNS settings to propagate (usually changes take effect instantly after `terraform` completes deployment). Visit both your website domain address and your CV address, confirming they are both publicly accessible and showing as secure. Any errors will be highlighted by `terraform` in the output logs.  


## 

![AWS](https://img.shields.io/badge/cloud-AWS-orange?logo=amazon-aws&style=flat-square&logoColor=white&style=flat-square&logoWidth=20) ![GCP](https://img.shields.io/badge/cloud-GCP-blue?logo=google-cloud&style=flat-square&logoColor=white&style=flat-square&logoWidth=20)

![Terraform](https://img.shields.io/badge/tool-Terraform-blueviolet?logo=terraform&style=flat-square&logoColor=white&style=flat-square&logoWidth=20) ![Docker](https://img.shields.io/badge/tool-Docker-blue?logo=docker&style=flat-square&logoColor=white&style=flat-square&logoWidth=20)

![JavaScript](https://img.shields.io/badge/language-JavaScript-yellow?logo=javascript&style=flat-square&logoColor=white&style=flat-square&logoWidth=20) ![Python](https://img.shields.io/badge/language-Python-blue?logo=python&style=flat-square&logoColor=white&style=flat-square&logoWidth=20)