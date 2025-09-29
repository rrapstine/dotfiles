function homelab --description "Work with homelab repository using git"
    set -l action $argv[1]
    set -l remote_user "richard"
    set -l remote_host "192.168.69.1"
    set -l remote_repo_path "/etc/nixos"  # Adjust this path as needed
    set -l flake_target "compostlab"  # Set the specific flake target

    # Check if we're in a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    switch $action
        case "sync"
            # Ensure all changes are committed
            echo "Checking for uncommitted changes..."
            if test (git status --porcelain | wc -l) -gt 0
                echo "You have uncommitted changes. Please commit before syncing."
                return 1
            end

            # Get current branch
            set -l current_branch (git rev-parse --abbrev-ref HEAD)

            # Push directly to the homelab remote
            echo "Pushing to homelab remote..."
            git push homelab $current_branch

            if test $status -ne 0
                echo "Failed to push changes to homelab"
                return 1
            end

            echo "Remote repository synchronized"

        case "build"
            # First run local tests
            echo "Running local tests first..."
            homelab test
            if test $status -ne 0
                echo "Tests failed, aborting build"
                return 1
            end

            # Then sync using git
            echo "Tests passed, proceeding with sync..."
            homelab sync
            if test $status -ne 0
                echo "Sync failed, aborting build"
                return 1
            end

            # Build and automatically switch on the remote server
            echo "Building and switching configuration on remote server..."

            # Use -t to allocate a pseudo-terminal for interactive output
            ssh -t $remote_user@$remote_host "cd $remote_repo_path && sudo nixos-rebuild switch --flake .#$flake_target"

            set -l build_status $status
            if test $build_status -ne 0
                echo "Build failed with status $build_status"
                return $build_status
            else
                echo "Build completed and configuration switched on remote server"
            end

        case "test"
            # Test in the local container with full stack trace
            echo "Testing configuration in local container..."
            podman-compose run --rm nix-dev bash -c "cd /homelab && nix flake check --show-trace"

            set -l test_status $status
            if test $test_status -ne 0
                echo "Test failed with status $test_status"
                return $test_status
            else
                echo "Test completed successfully in local container"
            end

        case "commit"
            # Helper for quick commits with a message
            if test (count $argv) -lt 2
                echo "Usage: homelab commit \"Your commit message\""
                return 1
            end
            git add .
            git commit -m "$argv[2]"
            echo "Changes committed. Use 'homelab sync' to push and sync with server."

        case "*"
            echo "Usage: homelab [sync|build|test|commit]"
            echo "  sync     - Push changes directly to homelab repository"
            echo "  build    - Test, sync, build and switch configuration on remote server"
            echo "  test     - Test configuration in local container with full stack trace"
            echo "  commit   - Commit local changes (requires message)"
    end
end
