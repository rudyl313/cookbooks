require_recipe "apt"

package "build-essential"
package "gfortran"
package "git-core"
package "libncurses5-dev"
package "libopenblas-dev"
package "m4"

git "/tmp/julia" do
  repository "git://github.com/JuliaLang/julia.git"
  reference "master"
  action :checkout
  not_if { `ls /usr/local/bin`.include?("julia") }
end

template "/tmp/julia/Make.inc" do
  source "Make.inc.erb"
  mode "0644"
  not_if { `ls /usr/local/bin`.include?("julia") }
end

bash "compile julia" do
  code "make"
  cwd "/tmp/julia"
  not_if { `ls /usr/local/bin`.include?("julia") }
end

bash "install julia" do
  code "cp julia /usr/local/bin/ && cp -r usr/* /usr/local/"
  cwd "/tmp/julia"
  not_if { `ls /usr/local/bin`.include?("julia") }
end

directory "/tmp/julia" do
  recursive true
  action :delete
end
