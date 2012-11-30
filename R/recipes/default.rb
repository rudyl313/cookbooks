include_recipe "apt"

package "libssl0.9.8"
package "libapparmor1"
package "apparmor-utils"

apt_repository "cran" do
  uri "http://cran.opensourceresources.org/bin/linux/ubuntu #{node[:R][:distro]}/"
  keyserver "keyserver.ubuntu.com"
  key "E084DAB9"
  action :add
  notifies :run, resources(:execute => "apt-get update"), :immediately
  not_if "[ -f /usr/sbin/rstudio-server ]"
end

package "r-base" do
  options "--force-yes"
end

package "r-base-dev" do
  options "--force-yes"
end

if node[:R][:packages].empty?

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

end
