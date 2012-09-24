version = node[:haskell][:platform_version]
base_url = node[:haskell][:platform_base_url]

#-------------------------------------------------------------------------------
# Basic Software Requirements
#-------------------------------------------------------------------------------

require_recipe "apt"
require_recipe "build-essential"
require_recipe "haskell::ghc"

#-------------------------------------------------------------------------------
# Packages
#-------------------------------------------------------------------------------

package "zlib1g-dev"
package "freeglut3-dev"

#-------------------------------------------------------------------------------
# Remote files
#-------------------------------------------------------------------------------

remote_file "/tmp/haskell-platform-#{version}.tar.gz" do
  source "#{base_url}#{version}/haskell-platform-#{version}.tar.gz"
  not_if do `ls /usr/local/share/doc`.include?("haskell-platform") end
end

#-------------------------------------------------------------------------------
# Installation actions
#-------------------------------------------------------------------------------

bash "unpack-haskell-platform-tar" do
  cwd "/tmp"
  code "tar zxvf haskell-platform-#{version}.tar.gz"
  not_if do `ls /usr/local/share/doc`.include?("haskell-platform") end
end

bash "configure-haskell-platform" do
  cwd "/tmp/haskell-platform-#{version}"
  code "./configure --enable-unsupported-ghc-version"
  not_if do `ls /usr/local/share/doc`.include?("haskell-platform") end
end

bash "compile-haskell-platform" do
  cwd "/tmp/haskell-platform-#{version}"
  code "make"
  not_if do `ls /usr/local/share/doc`.include?("haskell-platform") end
end

bash "install-haskell-platform" do
  cwd "/tmp/haskell-platform-#{version}"
  code "make install"
  not_if do `ls /usr/local/share/doc`.include?("haskell-platform") end
end

#-------------------------------------------------------------------------------
# Update Cabal
#-------------------------------------------------------------------------------

execute "update-cabal" do
  user node[:haskell][:cabal_user]
  command "cabal update"
  user node[:haskell][:cabal_user]
  environment({'USER' => node[:haskell][:cabal_user],
               'HOME' => node[:haskell][:cabal_user_home]})
end

#-------------------------------------------------------------------------------
# Cleanup
#-------------------------------------------------------------------------------

directory "/tmp/haskell-platform-#{version}" do
  recursive true
  action :delete
end

file "/tmp/haskell-platform-#{version}.tar.gz" do
  action :delete
end
