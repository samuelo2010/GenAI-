## Final Improved Jac Pseudo-Code for CodeGenius (Backend)


#Import the Python utility module
import from repo_utils { validate_repo_url, clone_repository, generate_file_tree }
import from byllm.llm { Model }

# Global LLM Model for all agents
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# ====================================================================
#  AGENT NODES
# ====================================================================

node RepoMapper {
    has repo_url: str;
    has repo_path: str;
    has file_tree: str = "";
    has readme_summary: str = "";

    # byllm function for README summarization (LLM-driven task)
    def summarize_readme(repo_path: str) -> str byllm();

    can execute with CodeGenius entry {
        # 1. Generate File Tree (Delegated to Python)
        print("[RepoMapper] Generating file tree via Python utility...");
        self.file_tree = generate_file_tree(self.repo_path);
        
        if self.file_tree.starts_with("ERROR"){
            report {"status": "ERROR", 
            "message": self.file_tree};
            return;}

        # 2. Summarize README (Delegated to LLM)
        print("[RepoMapper] Summarizing README via byLLM...");
        self.readme_summary = self.summarize_readme(self.repo_path);
        
        # Report results back to the Supervisor
        report {
            "file_tree": self.file_tree,
            "readme_summary": self.readme_summary,
            "status": "COMPLETED"
        };
    }
}

node CodeAnalyzer {
    # ... (CodeAnalyzer logic remains the same, but would use a Tree-sitter Python module) ...
    has repo_path: str;
    has ccg: str = "";
    has file_to_analyze: str;
    
    # byllm function for code analysis and CCG construction
    # This would internally call a Python module for Tree-sitter parsing
    def analyze_and_build_ccg(repo_path: str, file_path: str) -> dict byllm();

    can execute with CodeGenius entry {
        #... (Implementation remains the same) ...
        analysis_result = self.analyze_and_build_ccg(self.repo_path, self.file_to_analyze);
        self.ccg = analysis_result.ccg;
        
        report {
            "ccg": self.ccg,
            "dependencies": analysis_result.dependencies,
            "status": "COMPLETED"
        };
    }
}

node DocGenie {    
    #... (DocGenie logic remains the same) ...
    has aggregated_docs: dict;
    has final_documentation: str = "";
    def assemble_final_report(aggregated_docs: dict) -> str byllm();

    can execute with CodeGenius entry {
        self.final_documentation = self.assemble_final_report(self.aggregated_docs);
        report {"documentation": self.final_documentation, "status": "COMPLETED"};
    }
}

# ====================================================================
# SUPERVISOR WALKER (Code Genius) - Uses Python Module
# ====================================================================

walker CodeGenius {
    has repo_url: str;
    has repo_path: str;
    has aggregated_docs: dict = {};
    has analysis_queue: list = [];
    has documented_files: set = {};

    # 1. Main Orchestration Logic
    can execute with `root entry {
        # 1.1. Validation (Delegated to Python)
        print("[CodeGenius] Validating repository URL...");
        validation_result = validate_repo_url(self.repo_url);
        
        if validation_result.status == "ERROR":
            print("Pipeline failed: " + validation_result.message);
            report {"status": "ERROR", "message": validation_result.message};
            disengage;

        # 1.2. Cloning (Delegated to Python)
        print("[CodeGenius] Cloning repository...");
        repo_name = self.repo_url.split("/")[-1].replace(".git", "");
        local_path = "/tmp/repos/" + repo_name;
        
        clone_result = clone_repository(self.repo_url, local_path);
        
        if clone_result.status == "ERROR":
            print("Pipeline failed: " + clone_result.message);
            report {"status": "ERROR", "message": clone_result.message};
            disengage;
            
        self.repo_path = clone_result.path;

        # 1.3. Repo Mapping (Delegation to RepoMapper)
        print("[CodeGenius] Delegating to RepoMapper...");
        mapper_node = here ++> RepoMapper(repo_url=self.repo_url, repo_path=self.repo_path);
        visit mapper_node;
        
        repo_map_result = report_from(mapper_node);
        
        if repo_map_result.status == "ERROR":
            print("Pipeline failed during Repo Mapping.");
            report {"status": "ERROR", "message": "Repo Mapping failed."};
            disengage;

        file_tree = repo_map_result.file_tree;
        readme_summary = repo_map_result.readme_summary;

        # 1.4. High-Level Planning (LLM-based Prioritization)
        # ... (Prioritization logic remains the same, using byLLM) ...
        self.analysis_queue = self.prioritize_files(file_tree, readme_summary);

        # 1.5. Iterative Analysis Loop
        # ... (Loop logic remains the same) ...
        while self.analysis_queue.len() > 0:
            current_file = self.analysis_queue.pop_front();
            
            # ... (Delegation to CodeAnalyzer and aggregation) ...
            analyzer_node = here ++> CodeAnalyzer(repo_path=self.repo_path, file_to_analyze=current_file);
            visit analyzer_node;
            
            analysis_result = report_from(analyzer_node);
            
            if analysis_result.status == "COMPLETED":
                self.aggregated_docs[current_file] = analysis_result.ccg;
                self.documented_files.add(current_file);
                
                for dep_file in analysis_result.dependencies:
                    if dep_file not in self.documented_files and dep_file not in self.analysis_queue:
                        self.analysis_queue.push_back(dep_file);
            else:
                print("Analysis failed for " + current_file);

        # 1.6. Documentation Generation (Delegation to DocGenie)
        print("[CodeGenius] Delegating to DocGenie for final assembly...");
        docgenie_node = here ++> DocGenie(aggregated_docs=self.aggregated_docs);
        visit docgenie_node;
        
        final_doc_result = report_from(docgenie_node);
        
        # 1.7. Final Output
        if final_doc_result.status == "COMPLETED":
            print("Final Documentation Generated.");
            # Final report to the API interface
            report {
                "status": "SUCCESS",
                "documentation": final_doc_result.documentation
            };
        else:
            print("Final documentation failed.");
            report {"status": "ERROR", "message": "Final documentation failed."};
    }
    
    # Helper functions for byLLM prioritization (omitted for brevity)
    def prioritize_files(file_tree: str, readme_summary: str) -> list by llm();
    
}

