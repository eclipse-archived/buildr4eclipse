###############################################################################
# Copyright (c) 2009 Buildr4Eclipse and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Buildr4Eclipse - initial API and implementation
###############################################################################

require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "buildr4eclipse"
  s.rubyforge_project = "buildr4eclipse"
  s.version = "0.0.1"
  s.author = "Buildr4Eclipse"
  s.email = "buildr4eclipse@googlegroups.com"
  s.homepage = "http://buildr4eclipse.rubyforge.org"
  s.platform = $platform || RUBY_PLATFORM[/java/] || 'ruby'
  s.summary = "A Plugin Buildr for Eclipse that Doesn't Suck"
  s.files = Dir["bin/**/*", "lib/**/*", "tasks/**/*", "test/**/*", "spec/**/*", "features/**/*", "README", "ChangeLog", "LICENSE"]
  s.require_path = "lib"
  s.autorequire = "rake"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "ChangeLog", "LICENSE"]
  
  # dependencies of buildr4eclipse
  s.add_dependency("buildr", ">= 1.3.3")
  s.add_dependency("jdtc", ">= 0.0.1")
  
  # development time dependencies
  s.add_development_dependency("cucumber")
  
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new
rescue LoadError
  puts "Cucumber required. Please run 'rake setup' first"
end


task('license').enhance FileList[spec.files].exclude('.class', '.png', '.jar', '.tif', '.textile', '.icns',
   'README', 'LICENSE', 'ChangeLog')

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:test, :spec, :features]
