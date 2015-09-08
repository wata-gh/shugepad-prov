include_recipe 'selinux::disabled'
include_recipe "rbenv::system"

service 'iptables' do
  action [:disable, :stop]
end
service 'ip6tables' do
  action [:disable, :stop]
end

execute 'change localtime to JST' do
  user 'root'
  command <<-EOC
  cp -p /usr/share/zoneinfo/Japan /etc/localtime
  echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
  echo 'UTC=false' >> /etc/sysconfig/clock
  EOC
end

package 'python-setuptools'

execute 'install aws-cli' do
  user 'root'
  command <<-EOS
    easy_install pip
    pip install awscli
EOS
end

directory '/app/shugepad' do
  owner 'webservice'
  group 'webservice'
  mode  '755'
  action :create
end
