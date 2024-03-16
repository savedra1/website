

import requests

# API key obtained from Google Cloud Console
api_key = 'AIzaSyCH4eRIeEMuruGsuNIGK3vPhuHiakp0cm8'

# ID of the Google Doc you want to convert
doc_id = '1KEXZPU3h4E-BetoxT_DSPvy4eOeOfxJvuMS8tdwhE-s'

# Retrieve the Google Doc content
doc_url = f'https://docs.googleapis.com/v1/documents/{doc_id}?key={api_key}'
response = requests.get(doc_url)
doc_data = response.json()

print(doc_data)

## Extract the content from the response
#doc_content = ""
#for element in doc_data['body']['content']:
#    if 'paragraph' in element:
#        doc_content += ''.join([p['text']['content'] for p in element['paragraph']['elements']])
#
## Convert to PDF
#pdf_url = f'https://docs.googleapis.com/v1/documents/{doc_id}/export?mimeType=application/pdf&key={api_key}'
#pdf_response = requests.get(pdf_url)
#
## Save or use the PDF content as required
#with open('output.pdf', 'wb') as f:
#    f.write(pdf_response.content)