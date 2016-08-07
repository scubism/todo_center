# Vagrant tips

## How to fix vagrant-1.8.5 ssh login probrem

Vagrant 1.8.5 has probrem for ssh key pair copy process. You must patch the following code.

```sh
sudo vim /opt/vagrant/embedded/gems/gems/vagrant-1.8.5/plugins/guests/linux/cap

 54             if test -f ~/.ssh/authorized_keys; then
 55               grep -v -x -f '#{remote_path}' ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.tmp
 56               mv ~/.ssh/authorized_keys.tmp ~/.ssh/authorized_keys
 57               chmod 600 ~/.ssh/authorized_keys   # append this line
 58             fi
```
