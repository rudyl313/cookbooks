include_recipe "apt"

package "python-software-properties"

execute "install octave repository" do
  command <<-CODE
    apt-add-repository ppa:dr-graef/octave-3.6.precise
    apt-get update
  CODE
  not_if "[ -f /usr/bin/octave ]"
end

package "octave"
