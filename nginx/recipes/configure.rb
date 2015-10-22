node[:deploy].each do |application, deploy|
  template "/etc/nginx/conf.d/#{application}.conf" do
    cookbook 'nginx'
    source 'nginx.conf.erb'
    mode '0644'
    owner 'root'
    group 'root'
    variables(
      :application => application
    )
  end
end
