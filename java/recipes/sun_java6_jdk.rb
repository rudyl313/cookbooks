require_recipe "apt"

source_file = "/etc/apt/sources.list"
new_sources = [ "deb http://archive.canonical.com/ubuntu lucid partner",
                "deb-src http://archive.canonical.com/ubuntu lucid partner" ]

new_sources.each do |source|
  execute "echo '#{source}' >> #{source_file}" do
    not_if do `java -version`.include?("Java(TM) SE Runtime Environment") end
  end
end

execute "apt-get update" do
  not_if do `java -version`.include?("Java(TM) SE Runtime Environment") end
end

cookbook_file "/tmp/license_accept.txt" do
  source "license_accept.txt"
  mode "0644"
  not_if do `java -version`.include?("Java(TM) SE Runtime Environment") end
end

execute "/usr/bin/debconf-set-selections /tmp/license_accept.txt" do
  not_if do `java -version`.include?("Java(TM) SE Runtime Environment") end
end

package "sun-java6-jdk"

file "/tmp/license_accept.txt" do
  action :delete
end
