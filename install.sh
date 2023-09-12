#!/usr/bin/env bash

path_to_check="${HOME}/bin"

IFS=":" read -ra path_array <<< "$PATH"
path_exists=false

for path in "${path_array[@]}"; do
    if [ "$path" = "$path_to_check" ]; then
        path_exists=true
        break
    fi
done

# 输出结果
if [ "$path_exists" != true ]; then
	if [[ ! -d ${HOME}/bin ]]; then
		echo 'Create an environment directory for command "madb"'
		mkdir "${HOME}/bin"
	fi
	current_shell=$(basename "$SHELL")
	if [ "$current_shell" = "zsh" ]; then
			echo 'Add madb execution environment to PATH'
			echo -e '\nexport PATH="'"$path_to_check"':$PATH"' >> ~/.zshrc
	elif [ "$current_shell" = "bash" ]; then
			echo 'Add madb execution environment to PATH'
			echo -e '\nexport PATH="'"$path_to_check"':$PATH"' >> ~/.bash_profile
	else
    	echo "Unknown shell environment, please refer to the README.md for manual installation."
			exit 1
	fi
fi

cp ./madb.sh ${path_to_check}/madb
chmod +x ${path_to_check}/madb
echo "Installed Successfully!"
