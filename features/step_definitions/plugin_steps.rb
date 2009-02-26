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

Given /a project that should act as a plugin/ do
  @plugin_project = define('foo') do |project|
    act_as_eclipse_plugin
  end
  @pNotPlugin = define('bar')
end
  
Then /Buildr4eclipse should add a set of attributes and methods to help package the plugin/ do
  (@plugin_project.public_methods.include? "autoresolve").should be_true
  (@plugin_project.public_methods.include? "project_id").should be_true
  (@pNotFeature.public_methods.include? "autoresolve").should be_false
  # Also check if you can call the method right after the act_as_eclipse_feature method call.
  define('com.foo.bar') do |p|
    act_as_eclipse_plugin
    lambda {p.autoresolve()}.should_not raise_error
    lambda {p.project_id()}.should_not raise_error
  end
end

Given /the plugin with id '(.*)'/ do |plugin_id|
  cp_r "../../test-plugins/#{plugin_id}", Dir.pwd
  @plugin_project = define(plugin_id) do |project|
    act_as_eclipse_plugin
  end
end

When /^the plugin is compiled using jdt compiler$/ do
  @plugin_project.compile.invoke
end

Then /the plugin should be packaged as a plugin jar/ do
  pending
  p @plugin_project.package
end

Then /^the layout should be of type '(.*)'$/ do |layout_type|
  @plugin_project.layout.class.to_s.eql?(layout_type).should be_true
end
