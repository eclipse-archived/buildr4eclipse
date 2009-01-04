%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }

# It would have been best to put the version in the library files, but they require buildr, which in turn messes up the rake tasks available.

_VERSION = '0.0.1'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('buildr4eclipse', _VERSION) do |p|
  p.developer('Ketan Padegaonkar', 'buildr4eclipse@googlegroups.com')
  p.developer('Antoine Toulme', 'buildr4eclipse@googlegroups.com')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.post_install_message = 'PostInstall.txt'
  p.rubyforge_name       = p.name
  p.extra_deps         = [
     ['buildr','>= 1.3.3']
   ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# task :default => [:spec, :features]
