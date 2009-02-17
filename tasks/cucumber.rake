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


begin
  require 'cucumber/rake/task'
  desc "Run the features under features"
  Cucumber::Rake::Task.new
rescue LoadError
  puts "Cucumber required. Please run 'rake setup' first"
end

