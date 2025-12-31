import os
import subprocess
import sys

def get_size(path):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if not os.path.islink(fp):
                total_size += os.path.getsize(fp)
    return total_size / (1024 * 1024)  # MB

def run_git_cmd(args):
    print(f"Running: {' '.join(args)}")
    result = subprocess.run(args, capture_output=True, text=True)
    if result.returncode != 0:
        if "nothing to commit" in result.stdout or "nothing to commit" in result.stderr:
            print("Nothing to commit.")
            return True
        print(f"Error: {result.stderr}")
        return False
    return True

def batch_push(target_dir, max_batch_size=30):
    if not os.path.exists(target_dir):
        print(f"Directory {target_dir} does not exist.")
        return

    subdirs = [os.path.join(target_dir, d) for d in os.listdir(target_dir) if os.path.isdir(os.path.join(target_dir, d))]
    files = [os.path.join(target_dir, f) for f in os.listdir(target_dir) if os.path.isfile(os.path.join(target_dir, f))]
    
    subdirs.sort()
    
    # Push top-level files first
    if files:
        print(f"Pushing top-level files in {target_dir}...")
        if run_git_cmd(["git", "add"] + files):
            run_git_cmd(["git", "commit", "-m", f"Add files in {target_dir}"])
            run_git_cmd(["git", "push"])
            
    current_batch = []
    current_size = 0
    
    for subdir in subdirs:
        size = get_size(subdir)
        
        if size > max_batch_size:
            print(f"Directory {subdir} is {size:.2f}MB, which is larger than batch size {max_batch_size}MB. Recursing...")
            # Push whatever we have so far
            if current_batch:
                print(f"Pushing batch of size {current_size:.2f}MB before recursing...")
                if run_git_cmd(["git", "add"] + current_batch):
                    run_git_cmd(["git", "commit", "-m", f"Add batch of {target_dir}"])
                    if not run_git_cmd(["git", "push"]):
                        print("Push failed. Stopping.")
                        return
                current_batch = []
                current_size = 0
            
            # Recurse
            batch_push(subdir, max_batch_size)
            continue
            
        if current_size + size > max_batch_size:
            # Push current batch
            print(f"Pushing batch of size {current_size:.2f}MB...")
            if run_git_cmd(["git", "add"] + current_batch):
                run_git_cmd(["git", "commit", "-m", f"Add batch of {target_dir}"])
                if not run_git_cmd(["git", "push"]):
                    print("Push failed. Stopping.")
                    return
            
            current_batch = []
            current_size = 0
            
        current_batch.append(subdir)
        current_size += size
        
    if current_batch:
        print(f"Pushing final batch of size {current_size:.2f}MB...")
        if run_git_cmd(["git", "add"] + current_batch):
            run_git_cmd(["git", "commit", "-m", f"Add final batch of {target_dir}"])
            run_git_cmd(["git", "push"])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 batch_push.py <directory>")
        sys.exit(1)
        
    target_dir = sys.argv[1]
    batch_push(target_dir)
