require_recipe "apt"
require_recipe "haskell::platform"

package "sqlite3"
package "libsqlite3-dev"

execute "install-yesod" do
  user node[:yesod][:user_name]
  command "cabal install yesod"
  environment({'HOME' => node[:yesod][:user_home]})
end

new_path = "#{node[:yesod][:user_home]}/.cabal/bin/"

execute "add yesod to path" do
  command "echo 'PATH=$PATH:#{new_path}' >> /etc/profile"
  not_if do `cat /etc/profile`.include?(new_path) end
end
