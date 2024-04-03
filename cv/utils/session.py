
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

def request_session() -> requests.Session:
    session = requests.Session()

    # Define a retry strategy
    retry_strategy = Retry(
        total=3,
        status_forcelist=[500, 501, 502, 503, 504],  # Retry on any server-side errors
        allowed_methods=["GET", "POST", "PATCH", "PUT"], # Ony GET required for now
        backoff_factor=3,  # sleep 3 seconds between retries
        raise_on_status=False  # Don't raise an exception for these status codes
    )
    # Create an adapter with the retry strategy
    adapter = HTTPAdapter(max_retries=retry_strategy)

    # Mount the adapter to the session for all http and https requests
    session.mount("http://", adapter)
    session.mount("https://", adapter)
    
    return session   