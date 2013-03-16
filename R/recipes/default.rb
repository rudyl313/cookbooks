include_recipe "apt"

package "libssl0.9.8"
package "libapparmor1"
package "apparmor-utils"
package "build-essential"

new_repo = "deb #{node[:R][:cran_mirror]}/bin/linux/ubuntu #{node[:R][:distro]}/"

bash "install cran repository" do
  user "root"
  group "root"
  cwd "/tmp"
  environment({'USER' => 'root', 'HOME' => '/root'})
  code <<-CODE
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
    gpg -a --export E084DAB9 | sudo apt-key add -
    echo '#{new_repo}' >> /etc/apt/sources.list
    apt-get update
  CODE
  not_if "[ -f /usr/bin/R ]"
end

package "r-base" do
  options "--force-yes"
end

package "r-base-dev" do
  options "--force-yes"
end

template "/tmp/packages.R" do
  source "packages.R.erb"
  mode "755"
  owner "root"
  group "root"
end

bash "install packages" do
  user "root"
  group "root"
  cwd "/tmp"
  environment({'USER' => 'root', 'HOME' => '/root'})
  code "R --vanilla < packages.R"
end
