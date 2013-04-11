include_recipe "python"

package "g++"
package "gfortran"
package "libopenblas-dev"
package "liblapack-dev"

execute "pip install scipy"
