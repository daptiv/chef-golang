action :install do

  tmp_file_path = ::File.join Chef::Config[:file_cache_path], new_resource.name.gsub(/\//, '-')

  bash "#{node['golang']['install_dir']}/go/bin/go get -v #{new_resource.name} \
  2> >(grep -v '(download)$' > #{tmp_file_path})" do
    code "#{node['golang']['install_dir']}/go/bin/go get -v #{new_resource.name} \
    2> >(grep -v '(download)$' > #{tmp_file_path})"
    action :nothing
    user node['golang']['owner']
    group node['golang']['group']
    environment({
      'GOPATH' => node['golang']['gopath'],
      'GOBIN' => node['golang']['gobin']
    })
  end.run_action(:run)

  f = file tmp_file_path do
    content ''
  end
  f.run_action(:create)

  new_resource.updated_by_last_action(f.updated?)
end

action :update do

  tmp_file_path = ::File.join Chef::Config[:file_cache_path], new_resource.name.gsub(/\//, '-')

  bash "#{node['golang']['install_dir']}/go/bin/go get -v -u #{new_resource.name} \
  2> >(grep -v '(download)$' > #{tmp_file_path})" do
    code "#{node['golang']['install_dir']}/go/bin/go get -v -u #{new_resource.name} \
    2> >(grep -v '(download)$' > #{tmp_file_path})"
    action :nothing
    user node['golang']['owner']
    group node['golang']['group']
    environment({
      'GOPATH' => node['golang']['gopath'],
      'GOBIN' => node['golang']['gobin']
    })
  end.run_action(:run)

  f = file tmp_file_path do
    content ''
  end
  f.run_action(:create)

  new_resource.updated_by_last_action(f.updated?)
end

action :build do

  tmpdir = directory (::File.join Chef::Config[:file_cache_path], new_resource.name.gsub(/\//, '-') + \
    "_BUILD") do
      action :nothing
      owner node['golang']['owner']
      group node['golang']['group']
      recursive true
  end

  # create temporary directory to executing the build in
    tmpdir.run_action(:create)

  b = bash "Build #{new_resource.name}" do
    code "#{node['golang']['install_dir']}/go/bin/go build #{new_resource.name}"
    action :nothing
    cwd tmpdir.name
    user node['golang']['owner']
    group node['golang']['group']
    environment({
      'GOPATH' => node['golang']['gopath'],
      'GOBIN' => node['golang']['gobin']
    })
  end

  # execute the build
  b.run_action(:run)

  # remove temporary directory
  tmpdir.run_action(:delete)

  new_resource.updated_by_last_action(b.updated?)
end
