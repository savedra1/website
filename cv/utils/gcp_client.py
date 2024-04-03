import sys
import os
import json

from google.oauth2 import service_account
from google.auth.transport.requests import Request 

class Client:
    """
    GCP API Client used for handling files.
    """
    def __init__(self, session, doc_id) -> None:
        self.headers  = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.get_token()}"
        }        
        #self.session = session
        self.base_url = "https://www.googleapis.com"
        self.doc_id   = doc_id
        self.session  = session

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

        return access_token

    def get_doc_content(self) -> dict:
        """
        Returns all content and metadata form a google doc
        in json format.
        """
        url = f"https://docs.googleapis.com/v1/documents/{self.doc_id}"
        response = self.session.get(
            url,
            headers = self.headers
        )

        if response.status_code == 200:
            raise Exception(response.text)
        return json.loads(response.text)
    
    def export_as_pdf(self) -> bytes:
        """
        Returns byte data for a pdf, exported from and file
        with the users' drive, specefied by file id.
        """
        url = f"{self.base_url}/drive/v3/files/{self.doc_id}/export"
        query = {
            "mimeType": "application/pdf"
        }
        response = self.session.get(
            url,
            headers=self.headers,
            params=query
        )

        if response.status_code != 200:
            raise Exception(response.text)
        return response.content