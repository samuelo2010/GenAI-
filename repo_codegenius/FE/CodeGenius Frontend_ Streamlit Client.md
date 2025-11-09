# CodeGenius Frontend: Streamlit Client

This document details the setup and usage of the **CodeGenius** frontend, a Streamlit application that serves as the client interface for the Jac backend.

## 1. Frontend Overview

The frontend is a simple Python application built with Streamlit. Its primary functions are:
1.  Accepting a GitHub Repository URL from the user.
2.  Validating the URL format.
3.  Calling the Jac backend's `/walker/CodeGenius` API endpoint.
4.  Displaying the final Markdown documentation returned by the backend.

## 2. Frontend Files

| File | Description |
| :--- | :--- |
| `frontend_doc_generator_pseudocode.py` | The Streamlit application code. It handles the UI, user input, API calls to the Jac server, and rendering of the final documentation. |
| `refined_frontend_client_pseudocode.jac` | The Jac pseudo-code that represents the *client-side logic* for API interaction and result processing, which is conceptually implemented in the Python Streamlit file. |

## 3. Setup and Deployment

### 3.1. Prerequisites

*   Python 3.9+
*   Required Python packages: `streamlit`, `requests`.
*   The **CodeGenius Backend** must be running and accessible (e.g., at `http://localhost:8000`).

### 3.2. Installation Steps

1.  **Install Python Dependencies:**
    ```bash
    pip install streamlit requests
    ```
2.  **Run the Streamlit Application:**
    ```bash
    streamlit run frontend_doc_generator_pseudocode.py
    ```
3.  **Access:** The application will typically be available in your browser at `http://localhost:8501`.

## 4. Usage

1.  Ensure the Jac backend server is running.
2.  Open the Streamlit application in your browser.
3.  Enter a public GitHub URL (e.g., `https://github.com/jaseci-labs/jaseci`) into the input field.
4.  Click the **"Generate Documentation"** button.
5.  The application will display a loading spinner while the multi-agent pipeline executes on the backend.
6.  Once complete, the final Markdown documentation will be rendered directly on the page, along with a download button.
