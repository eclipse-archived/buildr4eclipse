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

When /the user types "buildr ([A-z|\:]*)"/ do |taskName|
  @task = task(taskName)
end

When /the user types "buildr (.*) (.*)"/ do |taskName, args|
  @task = task(taskName)
  @tasks.args = args
end
   
Then /Buildr should compute the data from this repository in a file named (.*) in the Buildr home directory/ do |config_file|
  pending
  @task.invoke
  p File.join(Buildr.application.home_dir, config_file)
  (File.exists? File.join(Buildr.application.home_dir, config_file)).should be_true
end

Given /a project depends over an artifact by specifying its version through a range, for example (.*)/ do |range|
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
     
Given /^a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered$/ do
pending
end

Then /^the dependencies of the project should be listed in a file named dependencies\.rb next to the buildfile$/ do
pending
end

Then /^that file should contain a yaml description of the dependencies, organized by subproject$/ do
pending
end

Then /^the artifacts the project depends on, ie the jar files or a jar'ed version of the directories should be copied to the local maven repository$/ do
pending
end

Then /^they should all use the group id "eclipse"$/ do
pending
end

Then /^the artifacts the project depends on, ie the jar files or a jar'ed version of the directories present in the local repository should be uploaded to http:\/\/www\.example\.com\/maven$/ do
pending
end

Then /^the missing plugin dependencies in the Eclipse instance should be copied to the dropins folder$/ do
pending
end

Then /^the \.classpath and \.project files should be generated for the project$/ do
pending
end
     