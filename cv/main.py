
# 1. get sheet data and convert to json
# 2. Save json file temporarily for TF to pick up 

import os
import logging
import sys
import json

import requests

from google.oauth2.credentials import Credentials
from google.oauth2 import service_account
from google.auth.transport.requests import Request 

"""
    https://developers.google.com/drive/v2/reference/files/insert 
    https://developers.google.com/drive/v2/reference/files/get
"""

class Client:
    def __init__(self, doc_id) -> None:
        self.headers  = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.get_token()}"
        }        
        #self.session = session
        self.base_url = "https://www.googleapis.com"
        self.doc_id   = doc_id

    @staticmethod
    def get_token() -> str: 
        """
        Return service account access token and
        Google API service credentials. 
        """

        scopes = [
            "https://www.googleapis.com/auth/docs",
            "https://www.googleapis.com/auth/drive",
        ]
        
        private_key    = os.getenv("GCP_SECRET_KEY").replace("|$|", "\n")
        private_key_id = os.getenv("GCP_PRIVATE_KEY_ID")
        project_id     = os.getenv("GCP_PROJECT_ID")
        client_email   = os.getenv("GCP_CLIENT_EMAIL")
        client_id      = os.getenv("GCP_CLIENT_ID")
        client_cert    = os.getenv("GCP_CLIENT_CERT")

        sa_info = {
            "type": "service_account",
            "project_id": project_id,
            "private_key_id": private_key_id,
            "private_key": private_key,
            "client_email": client_email,
            "client_id": client_id,
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": client_cert,
            "universe_domain": "googleapis.com"
        }
                
        creds = service_account.Credentials.from_service_account_info(
            info    = sa_info, 
            scopes  = scopes, 
        )
        
        if not creds.valid:
            try:
                creds.refresh(Request())
                access_token = creds.token
            except Exception as err:
                sys.exit(err)
        else:
            access_token = creds.token

        #print("TOKEN: ")
        #print(access_token)

        return access_token

    def get_doc_content(self) -> dict:
        url = f"https://docs.googleapis.com/v1/documents/{self.doc_id}"
        response = requests.get(
            url,
            headers = self.headers
        )

        if response.status_code == 200:
            raise Exception(response.text)
        return json.loads(response.text)
    
    def export_as_pdf(self):
        url = f"{self.base_url}/drive/v3/files/1KEXZPU3h4E-BetoxT_DSPvy4eOeOfxJvuMS8tdwhE-s"#{self.doc_id}/export"
        query = {
            "mimeType": "application/pdf"
        }
        response = requests.get(
            url,
            headers=self.headers,
            params=query
        )

        print(response.status_code)

        return response.content

if __name__ == "__main__":
    c = Client(os.getenv("GOOGLE_DOC_ID"))
    pdf_data = c.export_as_pdf()
    with open("cv.pdf", "wb") as pdf_file:
        pdf_file.write(pdf_data)



