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

require File.join(File.dirname(__FILE__), "use_cases.rb")

When /the user uses an environment variable named (.*) to point to one or more Eclipse instances/ do |var|
  ENV[var] = $eclipse_instances.join(";")
end

When /the user defines Eclipse instances in his buildr settings under the key (.*)/ do |settings_key|
  Buildr::write 'home/.buildr/settings.yaml', {"eclipse" => { "instances" => $eclipse_instances}}.to_yaml
end

Then /Buildr4eclipse should be aware of the Eclipse instances defined on the user system/ do
  Buildr.eclipse_instances.should == $eclipse_instances
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

Then /^the dependencies of the project should be listed in a file named (.*) next to the buildfile$/ do |file|
  @task.invoke
  (File.exists? File.join(@project.base_dir, file)).should be_true
end

Then /^(.*) should contain a yaml description of the dependencies, organized by subproject$/ do |file|
  require 'yaml'
  deps = YAML.load_file(File.join(@project.base_dir, file))
  deps["foo"].should == @foo_dependencies
  deps["foo:bar"].should == @foo_bar_dependencies
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
     