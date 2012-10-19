include_recipe "clojure::lein"
include_recipe "postgresql::server"

bash "change-cluster-encoding-to-utf8" do
  code <<-CODE
pg_dropcluster --stop 8.4 main
pg_createcluster --start -e UTF-8 8.4 main
CODE
  not_if do `sudo sudo -u postgres psql -l`.include?("UTF8") end
end

user = node[:clojure][:project_user]
pass = node[:clojure][:project_pass]
project_name = node[:clojure][:project_name]
project_dir = node[:clojure][:project_base_dir] + "/" +
  node[:clojure][:project_name]

bash "create-user" do
  user "postgres"
  code "echo -en '#{pass}\n#{pass}\n' | createuser -s -P #{user}"
  not_if do `sudo sudo -u postgres psql -c '\\du'`.include?(user) end
end

execute "create lein project" do
  cwd node[:clojure][:project_base_dir]
  user node[:clojure][:project_user]
  command "lein new #{project_name} && rm #{project_name}/project.clj"
  environment ({'HOME' => "/home/#{node[:clojure][:project_user]}"})
  not_if do `ls #{node[:clojure][:project_base_dir]}`.include?(project_name) end
end

template "#{project_dir}/project.clj" do
  source "postgresql_compojure_project.clj.erb"
  mode "0666"
  owner user
  group node[:clojure][:project_user_group]
  not_if do
    `ls #{project_dir}`.include?("project.clj") 
  end
end

execute "fetch deps" do
  cwd project_dir
  user node[:clojure][:project_user]
  command "lein deps"
  environment({'HOME' => "/home/#{node[:clojure][:project_user]}"})
end
