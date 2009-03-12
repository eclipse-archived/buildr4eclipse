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

require File.join(File.dirname(__FILE__), "step_helpers.rb")

Given /a Buildfile that mentions a special Eclipse repository/ do
  Buildr::write(Dir.pwd + "/eclipse/plugins/org.something_1.0.0.M456.jar")
  repositories.eclipse_instance = Dir.pwd + "/eclipse"
end

When /an artifact has a special group identifier, say "(.*)"/ do |groupId|
  @artifact = "#{groupId}:org.something:jar:1.0.0.M456"
end
   
Then /the artifact should be located in the Eclipse instance repositories/ do
  p = repositories.locate(@artifact)
  p.match(Dir.pwd + "/eclipse").should_not be_nil
end

When /the user asks for it by calling "buildr eclipse:repos"/ do
  @task = task("eclipse:repos")
end
   
Then /Buildr should compute the data from this repository in a file named (.*) in the Buildr home directory/ do |config_file|
  pending
  @task.invoke
  p File.join(Buildr.application.home_dir, config_file)
  (File.exists? File.join(Buildr.application.home_dir, config_file)).should be_true
end

Given /an artifact that version is actually a range, for example (.*)/ do |range|
  pending
end

When /^a project tries to resolve that artifact as a dependency to compile against it$/ do
  pending
end

Then /^it should be possible for the registered eclipse instances to compute a list of the plugins matching that version range$/ do
  pending
end

Then /^they should apply a strategy to select the appropriate artifact$/ do
  pending
end
     

     