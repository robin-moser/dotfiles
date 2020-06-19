# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Go Root dir
paths+=("/usr/local/go/bin")

# Go Project dir
paths+=("$HOME/go/bin")

# Comnposer vendor dir
paths+=("$HOME/.config/composer/vendor/bin")

# user bin dir
paths+=("$HOME/.local/bin")

# user bin dir
paths+=("$HOME/bin")

for path in "${paths[@]}"; do
    if [ -d "$path" ] ; then
        PATH="$path:$PATH"
    fi
done
