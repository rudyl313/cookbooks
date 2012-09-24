require_recipe "apt"

package "vim"
package "htop"
package "byobu"
package "git-core"
package "curl"

cookbook_file "/home/#{node[:dev_tools][:user]}/.vimrc" do
  source "vimrc"
  mode "0644"
  owner node[:dev_tools][:user]
  group node[:dev_tools][:group]
end

remote_file "/tmp/supertab.tar.gz" do
  source "https://github.com/ervandew/supertab/tarball/master"
  owner node[:dev_tools][:user]
  group node[:dev_tools][:group]
  mode "0666"
  not_if "[ -f /home/#{node[:dev_tools][:user]}/.vim/plugin/supertab.vim ]"
end

bash "install supertab" do
  cwd "/tmp"
  code <<-CODE
tar zxvf supertab.tar.gz
mkdir -p /home/#{node[:dev_tools][:user]}/.vim/plugin
cp ervandew-supertab*/plugin/supertab.vim /home/#{node[:dev_tools][:user]}/.vim/plugin/
rm supertab.tar.gz
rm -r edvandew-supertab*
chown -R #{node[:dev_tools][:user]}:#{node[:dev_tools][:group]} /home/#{node[:dev_tools][:user]}/.vim
CODE
  not_if "[ -f /home/#{node[:dev_tools][:user]}/.vim/plugin/supertab.vim ]"
end

remote_file "/home/#{node[:dev_tools][:user]}/.vim/plugin/R.vim" do
  source "http://www.vim.org/scripts/download_script.php?src_id=12808"
  owner node[:dev_tools][:user]
  group node[:dev_tools][:group]
  mode "0666"
  not_if "[ -f /home/#{node[:dev_tools][:user]}/.vim/plugin/R.vim ]"
end
