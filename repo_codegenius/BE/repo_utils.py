import os
import re
import shutil
import subprocess
from pathlib import Path

# --- Configuration ---
# Directories to ignore when generating the file tree
IGNORE_DIRS = ['.git', '__pycache__', 'node_modules', '.venv', 'dist', 'build']

def validate_repo_url(url: str) -> dict:
    """
    Validates the GitHub URL format and checks for basic reachability.
    """
    # 1. Basic URL Format Validation
    regex = r"https?://(www\.)?github\.com/[\w-]+/[\w-]+"
    if not re.match(regex, url):
        return {"status": "ERROR", "message": "Invalid GitHub URL format."}

    # 2. Basic Reachability Check (using git ls-remote for efficiency)
    try:
        # Check if the remote repository exists without cloning
        subprocess.run(
            ['git', 'ls-remote', url],
            check=True,
            capture_output=True,
            text=True,
            timeout=10
        )
        return {"status": "SUCCESS", "message": "URL is valid and reachable."}
    except subprocess.CalledProcessError as e:
        return {"status": "ERROR", "message": f"Repository check failed (private/non-existent): {e.stderr.strip()}"}
    except subprocess.TimeoutExpired:
        return {"status": "ERROR", "message": "Repository check timed out."}
    except Exception as e:
        return {"status": "ERROR", "message": f"An unexpected error occurred during validation: {str(e)}"}

def clone_repository(url: str, local_path: str) -> dict:
    """
    Clones the repository into the specified local path.
    """
    repo_path = Path(local_path)
    
    # Clean up if directory exists and is not empty (for fresh clone)
    if repo_path.exists():
        shutil.rmtree(repo_path)
        
    try:
        subprocess.run(
            ['git', 'clone', '--depth', '1', url, local_path], # Use --depth 1 for faster clone
            check=True,
            capture_output=True,
            text=True,
            timeout=60 # Allow up to 60 seconds for cloning
        )
        return {"status": "SUCCESS", "path": local_path}
    except subprocess.CalledProcessError as e:
        return {"status": "ERROR", "message": f"Git clone failed: {e.stderr.strip()}"}
    except subprocess.TimeoutExpired:
        return {"status": "ERROR", "message": "Git clone timed out."}
    except Exception as e:
        return {"status": "ERROR", "message": f"An unexpected error occurred during cloning: {str(e)}"}

def generate_file_tree(repo_path: str) -> str:
    """
    Generates a structured file tree string, ignoring specified directories.
    """
    repo_dir = Path(repo_path)
    if not repo_dir.is_dir():
        return "ERROR: Repository path is not a directory."

    tree_lines = []
    
    def walk_dir(current_dir: Path, prefix: str = ''):
        contents = sorted(list(current_dir.iterdir()))
        
        for i, item in enumerate(contents):
            if item.name in IGNORE_DIRS:
                continue

            is_last = (i == len(contents) - 1)
            
            if item.is_dir():
                # Directory
                tree_lines.append(f"{prefix}{'└── ' if is_last else '├── '}{item.name}/")
                new_prefix = prefix + ('    ' if is_last else '│   ')
                walk_dir(item, new_prefix)
            else:
                # File
                tree_lines.append(f"{prefix}{'└── ' if is_last else '├── '}{item.name}")

    tree_lines.append(f"{repo_dir.name}/")
    walk_dir(repo_dir, '')
    
    return "\n".join(tree_lines)

if __name__ == '__main__':
    # Example usage (for testing the Python module directly)
    test_url = "https://github.com/jaseci-labs/jaseci"
    test_path = "/tmp/test_repo"
    
    print("--- Validation Test ---")
    validation_result = validate_repo_url(test_url)
    print(validation_result)
    
    if validation_result["status"] == "SUCCESS":
        print("\n--- Cloning Test ---")
        clone_result = clone_repository(test_url, test_path)
        print(clone_result)
        
        if clone_result["status"] == "SUCCESS":
            print("\n--- File Tree Test ---")
            tree = generate_file_tree(test_path)
            print(tree)
            
            # Clean up
            shutil.rmtree(test_path)
            print(f"\nCleaned up {test_path}")
