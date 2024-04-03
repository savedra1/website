import os

import pytest

from google.oauth2 import service_account
from google.auth.transport.requests import Request

@pytest.fixture
def scopes():
    return [
        "https://www.googleapis.com/auth/docs",
        "https://www.googleapis.com/auth/drive",
    ]

@pytest.fixture
def sa_info():
    return {
        "type": "service_account",
        "project_id": os.getenv("PROJECT_ID"),
        "private_key_id": os.getenv("PRIVATE_KEY_ID"),
        "private_key": os.getenv("SECRET_KEY"),
        "client_email": os.getenv("CLIENT_EMAIL"),
        "client_id": os.getenv("CLIENT_ID"),
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": os.getenv("CLIENT_CERT"),
        "universe_domain": "googleapis.com"
    }

# Test Google API access
def test_google_access(sa_info, scopes, subject):
    """
    Test to ensure all current scopes are still active and
    main service account can still be used to access the api
    service account
    """
    creds = service_account.Credentials.from_service_account_info(
        info = sa_info, 
        scopes = scopes, 
    )
    
    if not creds.valid:
        creds.refresh(Request())
        access_token = creds.token
    else:
        access_token = creds.token 
    
    assert access_token is not None