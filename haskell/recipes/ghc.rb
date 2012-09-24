version = node[:haskell][:ghc_version]
base_url = node[:haskell][:ghc_base_url]

require_recipe "apt"
require_recipe "build-essential"

package "libgmp3-dev"

remote_file "/tmp/ghc-#{version}-x86_64-unknown-linux.tar.bz2" do
  source "#{base_url}#{version}/ghc-#{version}-x86_64-unknown-linux.tar.bz2"
  not_if do `ls /usr/local/bin`.include?("ghc") end
end

bash "unpack-ghc-tar" do
  user "root"
  cwd "/tmp"
  code "tar xvjf ghc-#{version}-x86_64-unknown-linux.tar.bz2"
  not_if do `ls /usr/local/bin`.include?("ghc") end
end

link "/usr/lib/x86_64-linux-gnu/libgmp.so.3" do
  to "/usr/lib/x86_64-linux-gnu/libgmp.so"
end

bash "configure-ghc-installer" do
  user "root"
  cwd "/tmp/ghc-#{version}"
  #code "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/ && ./configure"
  code "./configure"
  not_if do `ls /usr/local/bin`.include?("ghc") end
end

bash "install-ghc" do
  user "root"
  cwd "/tmp/ghc-#{version}"
  code "make install"
  not_if do `ls /usr/local/bin`.include?("ghc") end
end

directory "/tmp/ghc-#{version}" do
  recursive true
  action :delete
end

file "/tmp/ghc-#{version}-x86_64-unknown-linux.tar.bz2" do
  action :delete
end
