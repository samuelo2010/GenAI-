import streamlit as st
import requests
import os

# Configuration for the backend API
# Assuming the backend is running on the default host and port for a local development environment
# The user's sample used http://localhost:8000, which we will keep as a placeholder.
# In a real deployment, this would be an environment variable or a configuration setting.
INSTANCE_URL = os.environ.get("BACKEND_URL", "http://localhost:8000")
WALKER_ENDPOINT = f"{INSTANCE_URL}/walker/CodeGenius"

# Placeholder for a user token. 
# The user's sample included a login/register flow to get a token.
# For simplicity and to focus on the core task, we will use a dummy token 
# as the actual login flow is outside the scope of the CodeGenius walker's function.
# A real application would need the full login logic from the sample.
DUMMY_TOKEN = "dummy_token_for_auth_header" 

def bootstrap_frontend(token: str):
    """Sets up the Streamlit application interface."""
    st.set_page_config(
        page_title="CodeGenius - AI Code Documentation Generator",
        page_icon="🧠",
        layout="wide"
    )

    st.title("🧠 CodeGenius - AI Code Documentation Generator")
    st.markdown("✨ **Generate comprehensive documentation for any public GitHub repository.**")
    st.markdown("---")

    # Initialize session state
    if "doc_results" not in st.session_state:
        st.session_state.doc_results = []
    if "loading" not in st.session_state:
        st.session_state.loading = False
    if "repo_url" not in st.session_state:
        st.session_state.repo_url = ""

    # Input form for the repository URL
    st.markdown("### 🔗 Enter GitHub Repository URL")
    
    repo_url = st.text_input(
        "GitHub Repository URL:",
        value=st.session_state.repo_url,
        placeholder="e.g., https://github.com/owner/repo-name.git or https://github.com/owner/repo-name"
    )
    
    st.session_state.repo_url = repo_url

    # Process button
    if st.button("🚀 Generate Documentation", use_container_width=True):
        if repo_url.strip():
            # Simple validation
            if not (repo_url.startswith("http") and "github.com" in repo_url):
                st.error("⚠️ Please enter a valid GitHub repository URL.")
            else:
                st.session_state.loading = True
                st.rerun()
        else:
            st.warning("⚠️ Please enter a repository URL!")

    # Show loading state and call the backend API
    if st.session_state.loading:
        with st.spinner(f"🧠 CodeGenius is analyzing {st.session_state.repo_url}... This may take a few minutes."):
            try:
                # The backend walker expects "repo_url" as input
                response = requests.post(
                    WALKER_ENDPOINT,
                    json={"repo_url": st.session_state.repo_url},
                    headers={"Authorization": f"Bearer {token}"},
                    timeout=300 # Set a long timeout for potentially long-running analysis
                )

                st.session_state.loading = False
                
                if response.status_code == 200:
                    result = response.json()
                    
                    # The backend returns a list of reports, we expect the final one
                    # The final report is the last element in the 'reports' list
                    reports = result.get("reports", [])
                    if reports:
                        final_report = reports[-1]
                    else:
                        final_report = {"status": "ERROR", "message": "No reports received from the backend."}

                    # Add the result to history
                    st.session_state.doc_results.insert(0, {
                        "repo_url": st.session_state.repo_url,
                        "timestamp": st.session_state.repo_url, # Use URL as a unique key for display
                        "report": final_report
                    })

                    # Keep only last 5 results
                    st.session_state.doc_results = st.session_state.doc_results[:5]
                    
                    st.success("✅ Documentation generation complete!")
                    st.rerun()
                else:
                    st.error(f"❌ Backend processing failed. Status Code: {response.status_code}. Response: {response.text}")
                    st.rerun() # Rerun to clear the spinner and show the error
                    
            except requests.exceptions.Timeout:
                st.session_state.loading = False
                st.error("⏰ Request timed out. The analysis took too long. Please try a smaller repository or check the backend status.")
                st.rerun()
            except requests.exceptions.ConnectionError:
                st.session_state.loading = False
                st.error(f"❌ Connection Error: Could not connect to the backend at {INSTANCE_URL}. Please ensure the backend server is running.")
                st.rerun()
            except Exception as e:
                st.session_state.loading = False
                st.error(f"❌ An unexpected error occurred: {str(e)}")
                st.rerun()

    # Display results
    if st.session_state.doc_results:
        st.markdown("---")
        st.markdown("## 📜 Recent Documentation Reports")

        for i, doc_entry in enumerate(st.session_state.doc_results):
            repo_url = doc_entry["repo_url"]
            report = doc_entry["report"]
            status = report.get("status", "UNKNOWN")
            
            header_icon = "✅" if status == "SUCCESS" else "❌"
            header_color = "green" if status == "SUCCESS" else "red"
            
            with st.expander(f"{header_icon} **{status}** - Documentation for `{repo_url}`"):
                st.markdown(f"**🔗 Repository URL:** `{repo_url}`")
                
                if status == "SUCCESS":
                    documentation = report.get("documentation", "No documentation found in the report.")
                    st.markdown("**📝 Generated Documentation:**")
                    # Display the documentation content as Markdown
                    st.markdown(documentation)
                    
                    # Add a download button for the documentation
                    st.download_button(
                        label="⬇️ Download Documentation (Markdown)",
                        data=documentation,
                        file_name=f"documentation_{repo_url.split('/')[-1].replace('.git', '')}.md",
                        mime="text/markdown"
                    )
                    
                elif status == "ERROR":
                    error_message = report.get("message", "An unknown error occurred during processing.")
                    st.error(f"**Error Details:** {error_message}")
                else:
                    st.warning(f"**Report Status:** {status}. Raw Report: {report}")

        # Clear history button
        if st.button("🗑️ Clear History", key="clear_history_btn"):
            st.session_state.doc_results = []
            st.session_state.repo_url = ""
            st.rerun()

    # Footer
    st.markdown("---")
    st.markdown("🤖 **Powered by CodeGenius**")


# The original sample included a login/register block. We will simulate the token retrieval
# to keep the focus on the Streamlit application logic.
# In a real scenario, the user would need to ensure their backend is running and accessible.
if __name__ == "__main__":
    # In a real application, you would implement the login/register logic here
    # to get a valid token from the backend, as shown in the user's sample.
    # For this task, we proceed with the dummy token.
    bootstrap_frontend(DUMMY_TOKEN)

    # Note for the user: The backend server must be running and accessible at INSTANCE_URL
    # for this application to work.
