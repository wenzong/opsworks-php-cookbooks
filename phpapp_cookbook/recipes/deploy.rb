node[:deploy].each do |application, deploy|

  # use opsworks ssh key management and load the key into the ec2 instance. 
  # it's helpful to have the deploy key loaded into the root user

  # copy ssh key to root user
  execute "touch /root/.ssh/id_deploy" do
    ignore_failure true
  end
  
  ssh_key = deploy[:scm][:ssh_key]
  
  execute "copy ssh_key" do
    command "echo '#{ssh_key}' > /root/.ssh/id_deploy"
  end
  
  execute "chmod 0600 /root/.ssh/id_deploy" do
    ignore_failure true
  end

  # clone the repo
  execute "cd /srv/www && ssh-agent bash -c 'ssh-add /root/.ssh/id_deploy; git clone #{deploy[:scm][:repository]} #{application}'" do
    ignore_failure true
  end

  # use simple git pull to deploy code changes
  execute "cd /srv/www/#{application} && git clean -df && git reset --hard && ssh-agent bash -c 'ssh-add /root/.ssh/id_deploy; git pull'"

  # composer install
  execute "cd /srv/www/#{application}/src && composer install --no-dev"

  execute "cd /srv/www/#{application}/src && chmod -R 777 storage/"

  # nginx and php-fpm
  execute "service nginx restart"
  execute "service php-fpm restart"
end
