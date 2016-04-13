# -*- mode: ruby -*-
# vi: set ft=ruby :

# required vagrant plugins
# - vagrant-rsync-back
# - vagrant-gatling-rsync

Vagrant.configure(2) do |config|
  config.vm.box = "docker_vm_centos7"
  config.vm.box_url = "https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.2-64-puppet/versions/1.0.0/providers/virtualbox.box"

  # config.vbguest.auto_update = false
  # config.vm.box_check_update = false
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = true
  end

  config.vm.network "private_network", ip: "100.94.47.221"
  # config.vm.network "public_network"

  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=776,fmode=777"]

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.cpus = 2
    vb.memory = "1024"
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision "shell", inline: <<-EOC

yum install -y deltarpm

yum -y update

yum -y install git

cat <<-'EOF' >/etc/yum.repos.d/docker.repo
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum -y install docker-engine
service docker start
systemctl enable docker.service
usermod -aG docker vagrant

curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

yum install -y kernel-devel kernel-headers dkms gcc gcc-c++
/etc/init.d/vboxadd setup

echo "cd /vagrant" >> /home/vagrant/.bashrc

  EOC

end
