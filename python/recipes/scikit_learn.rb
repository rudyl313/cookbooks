include_recipe "apt"
include_recipe "python"
include_recipe "python::numpy"
include_recipe "python::scipy"

execute "pip install -U scikit-learn"
