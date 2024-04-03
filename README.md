# About

This static website is hosted in AWS s3 and routed via AWS Cloudfront and Route53 to serve a custom domain with SSL validation. All AWS infrastructure involved is managed using Terraform. Continues integration and deployment is enabled with GitHub Actions and the Google Cloud API is used in the CICD pipeline for building a PDF file for my CV from a Google Doc.

__Deployemt pipeline__

<p align="center">

  <img src="./assets/diagram.png?raw=true" />

</p>


### TODO

- readme (diagrams)
- TF Module for easily spinning up a static site with HTTPS 