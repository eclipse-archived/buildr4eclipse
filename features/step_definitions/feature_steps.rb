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

Given /a project that should act as a feature/ do
  @p = define('foo') do |project|
    act_as_eclipse_feature
  end
  @pNotFeature = define('bar')
end
  
Then /Buildr4eclipse should add a set of attributes and methods to help package the feature/ do
  (@p.public_methods.include? "feature_xml").should be_true
  (@p.public_methods.include? "project_id").should be_true
  (@pNotFeature.public_methods.include? "feature_xml").should be_false
  # Also check if you can call the method right after the act_as_eclipse_feature method call.
  define('com.foo.bar') do |p|
    act_as_eclipse_feature
    lambda {p.feature_xml("myFeature", "1.0")}.should_not raise_error
    lambda {p.project_id}.should_not raise_error
  end
end

Given /a project identified as a feature, packaging plugins/ do
  pending
end

Then /Buildr4eclipse should bundle the plugins and generate the feature accordingly/ do
  pending
end