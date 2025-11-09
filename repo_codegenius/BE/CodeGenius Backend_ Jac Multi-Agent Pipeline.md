# CodeGenius Backend: Jac Multi-Agent Pipeline

This document details the setup and structure of the **CodeGenius** backend, which is responsible for the multi-agent orchestration, code analysis, and documentation generation.

## 1. Backend Architecture Overview

The backend is built around a multi-agent pipeline orchestrated by the **Code Genius (Supervisor)** walker.

| Agent | Role | Core Technology |
| :--- | :--- | :--- |
| **Code Genius (Supervisor)** | Orchestrates the entire workflow, manages the analysis queue, and aggregates results. | Jac (Walker) |
| **Repo Mapper** | Handles repository setup, including file-tree generation and README summarization. | Jac + Python (`repo_utils.py`) + byLLM |
| **Code Analyzer** | Performs deep code analysis, constructs the Code Context Graph (CCG), and identifies dependencies. | Jac + Python (Tree-sitter/Parsing) + byLLM |
| **DocGenie** | Synthesizes all structured data (CCG, file-tree, summaries) into the final Markdown report. | Jac + byLLM |

## 2. Backend Files

The backend logic is split between Jac code for orchestration and Python code for system-level tasks.

| File | Description |
| :--- | :--- |
| `final_backend_pseudocode.jac` | Contains the core Jac code: `CodeGenius` walker, `RepoMapper`, `CodeAnalyzer`, and `DocGenie` nodes. This is the main orchestration logic. |
| `repo_utils.py` | Python utility module for system-level tasks: URL validation, Git cloning, and file-tree generation. This module is imported by the Jac code using `py_module`. |
| `tree_sitter_utils.py` (Hypothetical) | Python module that would contain the actual code for parsing source files and building the CCG using a library like Tree-sitter. |

## 3. Setup and Deployment

### 3.1. Prerequisites

*   Jac Programming Environment (e.g., Jaseci or similar Jac runtime)
*   Python 3.9+
*   Required Python packages: `gitpython` (or ensure `git` is installed), `requests`, `regex`, `pathlib`, `tree-sitter` (for Code Analyzer).

### 3.2. Installation Steps

1.  **Install Python Dependencies:**
    ```bash
    pip install gitpython requests tree-sitter
    # Ensure the 'git' command-line tool is installed on your system
    ```
2.  **Deploy Jac Code:** Load the Jac files into your Jac runtime environment.
    ```bash
    # Example using Jaseci CLI
    jsctl start
    jsctl jac load final_backend_pseudocode.jac
    ```
3.  **Ensure Python Module is Accessible:** The `repo_utils.py` file must be in a location accessible by the Jac runtime (e.g., the same directory or configured in the Python path).
4.  **Start the Jac Server:** Ensure the Jac server is running and accessible, typically on `http://localhost:8000`. This server exposes the `/walker/CodeGenius` API endpoint used by the frontend.

### 3.3. API Endpoint

The primary API endpoint for the backend is:

*   **Endpoint:** `POST /walker/CodeGenius`
*   **Payload:** `{"repo_url": "your_github_url"}`
*   **Response:** The final report containing the generated documentation.
