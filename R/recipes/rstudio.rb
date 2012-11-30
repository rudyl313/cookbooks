require_recipe "R"

user "rstudio" do
  comment "Application execution user"
  uid 2000
  gid "users"
  shell "/bin/false"
  home "/home/rstudio"
end

directory "/home/rstudio" do
  owner "rstudio"
  group "users"
  mode 0755
  action :create
end

remote_file "/tmp/rstudio-server-#{node[:R][:rstudio_version]}-amd64.deb" do
  source "https://s3.amazonaws.com/rstudio-server/rstudio-server-#{node[:R][:rstudio_version]}-amd64.deb"
  checksum "49cb16aacb8f2dfffbd8a440f1e8a8be0bc1364cb94f9521b49fcf9f0e8bb90c"
  not_if "[ -f /usr/sbin/rstudio-server ]"
end

dpkg_package "rstudio-server" do
  source "/tmp/rstudio-server-#{node[:R][:rstudio_version]}-amd64.deb"
  not_if "[ -f /usr/sbin/rstudio-server ]"
end

file "/tmp/rstudio-server-#{node[:R][:rstudio_version]}-amd64.deb" do
  action :delete
end
