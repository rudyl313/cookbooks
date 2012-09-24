require_recipe "apt"
require_recipe "java"

package "unzip"

remote_file "#{node[:clojure][:install_dir]}/clojure.zip" do
  source "#{node[:clojure][:base_url]}/clojure-#{node[:clojure][:version]}.zip"
  mode "0644"
  not_if do
    contents = `ls #{node[:clojure][:install_dir]}`
    contents.include?("clojure-#{node[:clojure][:version]}")
  end
end

bash "unzip clojure" do
  cwd node[:clojure][:install_dir]
  code "unzip clojure.zip"
  not_if do 
    contents = `ls #{node[:clojure][:install_dir]}`
    contents.include?("clojure-#{node[:clojure][:version]}")
  end
end

jar_path = "#{node[:clojure][:install_dir]}/clojure-#{node[:clojure][:version]}"

template "#{node[:clojure][:bin_dir]}/clojure" do
  source "clojure.erb"
  mode "0755"
  variables({ :jar_path => jar_path })
end

file "#{node[:clojure][:install_dir]}/clojure.zip" do
  action :delete
end
