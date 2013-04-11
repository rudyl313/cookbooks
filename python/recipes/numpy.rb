include_recipe "apt"
include_recipe "python"

package "libopenblas-dev"
package "liblapack-dev"

execute "pip install numpy"
