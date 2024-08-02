# List directory on CD
function cd() {
	builtin cd "$@";
	ls;
}

# List directory when using zoxide
function z() {
	__zoxide_z $@;
	ls;
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$@"
}

# Create a new Laravel Sail project with the given name
function setsail() {
	# Prompt the user for the project name if none is passed as an argument
	if [ -z "$1" ]; then
		echo "Enter the project name:"
		read project_name
	else
		project_name=$1
	fi
	
	# Prompt the user for default or custom Sail configuration
	# Options are: default, custom
	configurations=("default" "custom")

	echo "Do you want to use the default Sail configuration or create a custom one?"
	select configuration in "${configurations[@]}"; do
		case $configuration in
			"default")
				configuration="default"
				break
				;;
			"custom")
				configuration="custom"
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# If the user wants to use the default Sail configuration, we're done
	if [ $configuration = "default" ]; then
		curl -s "https://laravel.build/${project_name}" | bash
		cd ${1}
		echo "\nProject created! Run 'sail up' to start the server."
		return
	fi

	# Prompt the user for what database they want to use
	# Options are: mysql, postgres, mariadb
	databases=("mysql" "postgres" "mariadb")

	echo "Choose a database:"
	select database in "${databases[@]}"; do
		case $database in
			"mysql")
				database="mysql"
				break
				;;
			"postgres")
				database="pgsql"
				break
				;;
			"mariadb")
				database="mariadb"
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# Prompt the user for what cache driver they want to use
	# Options are: redis, memcached, none
	caches=("redis" "memcached" "none")

	echo "Choose a cache driver:"
	select cache in "${caches[@]}"; do
		case $cache in
			"redis")
				cache="redis"
				break
				;;
			"memcached")
				cache="memcached"
				break
				;;
			"none")
				cache=0
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# Prompt the user if they want to use meilisearch
	# Options are: yes, no
	meilisearches=("yes" "no")

	echo "Do you want to use Meilisearch?"
	select meilisearch in "${meilisearches[@]}"; do
		case $meilisearch in
			"yes")
				meilisearch=1
				break
				;;
			"no")
				meilisearch=0
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# Prompt the user if they want to use minio
	# Options are: yes, no
	minios=("yes" "no")

	echo "Do you want to use Minio?"
	select minio in "${minios[@]}"; do
		case $minio in
			"yes")
				minio=1
				break
				;;
			"no")
				minio=0
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# Prompt the user if they want to use mailpit
	# Options are: yes, no
	mailpits=("yes" "no")

	echo "Do you want to use Mailpit?"
	select mailpit in "${mailpits[@]}"; do
		case $mailpit in
			"yes")
				mailpit=1
				break
				;;
			"no")
				mailpit=0
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# Prompt the user if they want to use selenium
	# Options are: yes, no
	seleniums=("yes" "no")

	echo "Do you want to use Selenium?"
	select selenium in "${seleniums[@]}"; do
		case $selenium in
			"yes")
				selenium=1
				break
				;;
			"no")
				selenium=0
				break
				;;
			*)
				echo "Invalid option $REPLY"
				;;
		esac
	done

	# Put it all together to create the options string
	# The options string is a comma-separated list of options only containing truthy values
	# Example: mysql,redis,meilisearch,minio,mailpit,selenium
	options_string="${database}"

	if [ $cache -eq 1 ]; then
		options_string="${options_string},${cache}"
	fi

	if [ $meilisearch -eq 1 ]; then
		options_string="${options_string},meilisearch"
	fi

	if [ $minio -eq 1 ]; then
		options_string="${options_string},minio"
	fi

	if [ $mailpit -eq 1 ]; then
		options_string="${options_string},mailpit"
	fi

	if [ $selenium -eq 1 ]; then
		options_string="${options_string},selenium"
	fi

	# Create the project using provided options
	echo "Creating a new project called ${project_name} with the following services: ${options_string}"
	curl -s "https://laravel.build/${project_name}?with=${options_string}" | bash
	cd ${project_name}
	echo "\nProject created! Run 'sail up' to start the server."
}