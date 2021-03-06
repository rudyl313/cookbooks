include_recipe "apt"

package "build-essential"
package "curl"
package "libyaml-dev"
package "libxml2-dev"

bash "install ruby via rvm" do
  code <<-CODE
curl -L get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
. /etc/profile
rvm install #{node[:ruby][:version]}
rvm use #{node[:ruby][:version]} --default
CODE
  environment({ 'HOME' => node[:ruby][:home], 'USER' => node[:ruby][:user] })
  not_if do
    `ls #{node[:ruby][:home]}`.include?("rvm") &&
    `find #{node[:ruby][:home]}/.rvm/ | grep ruby-`.include?(node[:ruby][:version])
  end
end
