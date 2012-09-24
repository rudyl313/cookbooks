require_recipe "apt"
require_recipe "java"

package "unzip"

remote_file "#{node[:play][:install_dir]}/play.zip" do
  source "#{node[:play][:base_url]}/play-#{node[:play][:version]}.zip"
  mode "0644"
  not_if do
    `ls #{node[:play][:install_dir]}`.include?("play-#{node[:play][:version]}")
  end
end

execute "unpack play" do
  cwd node[:play][:install_dir]
  command "unzip play.zip"
  only_if do `ls #{node[:play][:install_dir]}`.include?("play.zip") end
end

file "#{node[:play][:install_dir]}/play.zip" do
  action :delete
end

new_path = "#{node[:play][:install_dir]}/play-#{node[:play][:version]}/"

execute "add play to path" do
  command "echo 'PATH=$PATH:#{new_path}' >> /etc/profile"
  not_if do `cat /etc/profile`.include?(new_path) end
end
