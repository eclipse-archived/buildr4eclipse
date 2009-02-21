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
  s.add_dependency("buildr", "= 1.3.4")
  s.add_dependency("jdtc", "= 0.0.1")
  s.add_dependency("manifest", "= 0.0.2")
    
  # development time dependencies
  s.add_development_dependency "cucumber"
  s.add_development_dependency "ruby-debug"
  s.add_development_dependency 'rspec',                '1.1.12'
end
