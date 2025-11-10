## Improved Frontend Pseudo-Code for Documentation Generator (Streamlit/Python)

#This pseudo-code adapts the provided Streamlit structure to create a frontend for the multi-agent documentation pipeline. It focuses on accepting a GitHub URL, calling the Jac server's `CodeGenius` walker API, and rendering the final Markdown documentation.
import streamlit as st;
import requests;
import re; # For URL validation

#Assume the Jac server is running on this URL
#JAC_SERVER_URL:str = "http://localhost:8000";

def validate_github_url(url: str) -> bool{
    # Simple regex to check for a valid GitHub repository URL
    regex = r"https?://(www\.)?github\.com/[\w-]+/[\w-]+";
    return re.match(regex, url) is not None;}

def bootstrap_frontend(token: str){
    st.set_page_config(
        page_title="Code Documentation Generator - AI Agent",
        page_icon="📄",
        layout="wide"
    );

    st.title("📄 Code Documentation Generator");
    st.markdown("✨ Generate comprehensive Markdown documentation from any public GitHub repository using a multi-agent pipeline.");

    #Initialize session state
    if "doc_result" not in st.session_state{
        st.session_state.doc_result = [];
    }
    if "loading" not in st.session_state{
        st.session_state.loading = False;
    }
    if "repo_url" not in st.session_state{
        st.session_state.repo_url = "";}

    # Main interface: Input URL
    st.markdown("### 🔗 Enter GitHub Repository URL");
    
    repo_url_input = st.text_input(
        "GitHub URL:",
        value=st.session_state.repo_url,
        placeholder="e.g., https://github.com/jaseci-labs/jaseci"
    );
    st.session_state.repo_url = repo_url_input;

     #Process button
    if st.button("🚀 Generate Documentation", disabled=st.session_state.loading){
        if not repo_url_input.strip(){
            st.warning("⚠️ Please enter a GitHub URL.");}
        elif not validate_github_url(repo_url_input){
            st.error("❌ Invalid GitHub URL format. Please ensure it is a valid repository link.");
        } else{
            st.session_state.loading = True;
            st.session_state.doc_result = None;# Clear previous result
            st.rerun();}

    # Show loading state and API call
    if st.session_state.loading{
        with st.spinner(f"🧠 Multi-Agent Pipeline is running... {Cloning}, {Mapping}, {Analyzing}, {Generating}"){
            try{
                # API Endpoint: Call the CodeGenius walker
                response = requests.post(
                    f"{JAC_SERVER_URL}/walker/CodeGenius",
                    json={"repo_url": st.session_state.repo_url}, # Pass the URL as a walker argument
                    headers={"Authorization": f"Bearer {token}"},
                    timeout=300 # Set a long timeout for the complex pipeline
                );

                if response.status_code == 200{
                    result = response.json();
                    
                    #Extract the final documentation from the DocGenie report
                    # Assuming the final report is the last one and contains the 'documentation' key
                    reports = result.get("reports", []);
                    final_doc_report = reports[-1] if reports else {};
                    
                    if final_doc_report.get("documentation"){
                        st.session_state.doc_result = final_doc_report["documentation"];
                        st.success("✅ Documentation generated successfully!");}
                    else{
                        st.error("❌ Pipeline completed, but no documentation was found in the final report.");
                    }   
                    st.session_state.loading = False;
                    st.rerun();
                }
                else{
                    st.error(f"❌ Pipeline failed (Status {response.status_code}): {response.text}");
                    st.session_state.loading = False;}
            }    
            except requests.exceptions.Timeout{
                st.error("⏰ Request timed out. The pipeline may take a long time for large repositories.");
                st.session_state.loading = False;}
            except Exception as e{
                st.error(f"❌ An unexpected error occurred: {str(e)}");
         
                st.session_state.loading = False;
            }
        }
    }
    # Display results
    if st.session_state.doc_result{
        st.markdown("---");
        st.markdown("## 📝 Generated Documentation");
        
        # Use st.markdown to render the final Markdown documentation
        st.markdown(st.session_state.doc_result);
        
        # Add a download button for the Markdown file
        st.download_button(
            label="⬇️ Download Documentation (Markdown)",
            data=st.session_state.doc_result,
            file_name="repository_documentation.md",
            mime="text/markdown"
        );
    }

    # Footer (Simplified)
    st.markdown("---");
    st.markdown("**🤖 Powered by Code Genius Multi-Agent Pipeline**");
    
}

#Entry point logic (Login/Token Acquisition) remains the same
with entry{
    # ... (Login/Registration logic from pasted_content_3.txt) ...
    #... (Acquire 'token') ...
    
    # Example login logic (replace with actual Jac login implementation)
    INSTANCE_URL = "http://localhost:8000";
    TEST_USER_EMAIL = "test@mail.com";
    TEST_USER_PASSWORD = "password";
    
    # Simplified login/token acquisition for pseudo-code
    if response.status_code!=200{
        response = requests.post(
            f"{INSTANCE_URL}/user/login",
            json={"email": TEST_USER_EMAIL, "password": TEST_USER_PASSWORD}
        );
        assert response.status_code == 201;
        response=requests.post(f"{INSTANCE_URL}/user/login",
            json={"email": TEST_USER_EMAIL, "password": TEST_USER_PASSWORD});
            assert response.status_code==200;
    }
    token=response.json()[token];
    bootstrap_frontend(token);
}}
        

