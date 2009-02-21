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

def spec(platform = RUBY_PLATFORM[/java/] || 'ruby')
  @specs ||= ['ruby', 'java'].inject({}) { |hash, platform|
    $platform = platform
    hash.update(platform=>Gem::Specification.load('buildr4eclipse.gemspec'))
  }
  @specs[platform]
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end

task('license').enhance FileList[spec.files].exclude('.class', '.png', '.jar', '.tif', '.textile', '.icns',
   'README', 'LICENSE', 'ChangeLog')

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:spec, :features]
