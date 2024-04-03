

import os

from utils.gcp_client import Client
from utils.session    import request_session
from utils.logger     import custom_logger

if __name__ == "__main__":
    logger = custom_logger()
    doc_id = os.getenv("GOOGLE_DOC_ID")
    logger.info("Initialising client...")

    with request_session() as s:
        c = Client(s, doc_id)
        pdf_data = c.export_as_pdf()
        logger.info("PDF data successfully retreived.")

    with open("cv.pdf", "wb") as pdf_file:
        pdf_file.write(pdf_data)

    logger.info("Program complete.")

