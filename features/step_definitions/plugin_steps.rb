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

Then /Buildr4eclipse should add a set of attributes and methods to help package the plugin/ do
  (@project.respond_to? :manifest_dependencies).should be_true
  (@project.respond_to? :project_id).should be_true
  (@pNotPlugin.respond_to? :manifest_dependencies).should be_false
  # Also check if you can call the method right after the act_as_eclipse_feature method call.
  define('com.foo.bar') do |p|
    act_as_eclipse_plugin
    lambda {p.manifest_dependencies }.should_not raise_error
    lambda {p.project_id }.should_not raise_error
  end
end

When /^the plugin is compiled using jdt compiler$/ do
  @plugin_project.compile.invoke
end

Then /the plugin should be packaged as a plugin jar/ do
  @plugin_project.package.invoke
  files = FileList.new("#{File.expand_path @plugin_project.base_dir}/#{@plugin_project.target}/#{@plugin_project.project_id}*.jar")
  files.should_not be_empty
  File.exists?(files.first).should be_true
end

Then /^the layout should be of type '(.*)'$/ do |layout_type|
  @project.layout.class.to_s.eql?(layout_type).should be_true
end