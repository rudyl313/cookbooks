require_recipe "apt"
require_recipe "java"

remote_file "#{node[:clojure][:bin_dir]}/lein" do
  source "#{node[:clojure][:lein_base_url]}/lein"
  mode "0755"
  not_if do `ls #{node[:clojure][:bin_dir]}`.include?("lein") end
end
