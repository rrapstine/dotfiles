# List Directory on CD
function cd() {
	builtin cd "$@";
	ls;
}

# Run Homestead Commands Globally
function vm() {
   cd ~/Homestead

   command="$1"

   if [ "$command" = "edit" ]; then
      atom ~/.homestead/homestead.yaml
   else
      if [ -z "$command" ]; then
         command="ssh"
      fi

      eval "vagrant ${command}"
   fi

   # Switch Back To Directory Where Command Was Performed
   cd -
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}