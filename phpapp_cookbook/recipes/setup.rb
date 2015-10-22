include_recipe "build-essential"

# disable opcache fast shutdown
execute "sed -i 's/opcache.fast_shutdown=1/opcache.fast_shutdown=0/g' /etc/php.d/opcache.ini" do
    ignore_failure true
end
