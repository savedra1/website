
# 1. get sheet data and convert to json
# 2. Save json file temporarily for TF to pick up 

import os
import logging

import requests

from google.oauth2.credentials import Credentials
from google.oauth2 import service_account
from google.auth.transport.requests import Request 

"""
    https://developers.google.com/drive/v2/reference/files/insert 
    https://developers.google.com/drive/v2/reference/files/get
"""

# see https://stackoverflow.com/questions/21385477/generating-a-pdf-using-google-docs-api


class Client:
    def __init__(self) -> None:
        self.headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.get_token()}"
        }        
        #self.session = session
        self.base_url = "https://www.googleapis.com"
        #self.customer_id = '00000' # Not a secret

    @staticmethod
    def get_token() -> str: 
        """
        Return service account access token and
        Google API service credentials. 
        """

        scopes = [
            "https://www.googleapis.com/auth/docs",
            "https://www.googleapis.com/auth/drive",
            "https://www.googleapis.com/auth/drive.appdata",
            "https://www.googleapis.com/auth/drive.file",
            "https://www.googleapis.com/auth/drive.metadata",
            "https://www.googleapis.com/auth/drive.metadata.readonly",
            "https://www.googleapis.com/auth/drive.photos.readonly",
            "https://www.googleapis.com/auth/drive.readonly",
            "https://www.googleapis.com/auth/drive.apps.readonly"
        ]
        
        private_key    = os.getenv("GCP_SECRET_KEY").replace("$", "\n")
        private_key_id = os.getenv("GCP_PRIVATE_KEY_ID")
        project_id     = os.getenv("GCP_PROJECT_ID")
        client_email   = os.getenv("GCP_CLIENT_EMAIL")
        client_id      = os.getenv("GCP_CLIENT_ID")
        client_cert    = os.getenv("GCP_CLIENT_CERT")
        subject        = os.getenv("GCP_SUBJECT")
        #sheet_id       = os.getenv("GOOGLE_SHEET_ID")

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
            subject = subject
        )
        
        if not creds.valid:
            try:
                creds.refresh(Request())
                access_token = creds.token
            except Exception as err:
                print("ERR:\n" + err)
                return err
        else:
            access_token = creds.token

        print("TOKEN: ")
        print(access_token)

        return access_token

    def get_doc_content(self):
        url = f"https://docs.googleapis.com/v1/documents/1KEXZPU3h4E-BetoxT_DSPvy4eOeOfxJvuMS8tdwhE-s"
        response = requests.get(
            url,
            headers = self.headers
        )
        print("RESPONSE:\n" + response.text)
    

if __name__ == "__main__":
    c = Client()
    print(c.headers["Authorization"])
    #c.get_doc_content()


