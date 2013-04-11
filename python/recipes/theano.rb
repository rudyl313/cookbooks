include_recipe "python"
include_recipe "python::numpy"
include_recipe "python::scipy"

package "python-nose"
package "git"

execute "pip install Theano"
