if [ -f $HOME/.ssh/authorized_keys ]
then
        echo "Bienvenido"
else
        ssh-keygen
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
        cd ~/.ssh/
        chmod 600 authorized_keys
fi