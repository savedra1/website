
# 1. get sheet data and convert to json
# 2. Save json file temporarily for TF to pick up 


import requests
# Import google


endpoints = """
    https://developers.google.com/drive/v2/reference/files/insert 
    https://developers.google.com/drive/v2/reference/files/get
"""

# see https://stackoverflow.com/questions/21385477/generating-a-pdf-using-google-docs-api