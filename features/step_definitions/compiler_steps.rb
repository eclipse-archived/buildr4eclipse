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

# Point to the buildr source to run with Buildr's source. 

require 'ruby-debug'
Debugger.start

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '../../lib'))

require File.join(File.dirname(__FILE__), "/../../buildr/spec/spec_helpers.rb")
require 'buildr4eclipse'

World do |world|
  world.extend(Buildr)
  world.extend(SpecHelpers)
  world.extend(Sandbox)
end

Before do
  sandbox
  @custom_layout = Layout.new
end

After do
  reset
end

Then /the compiler should contain pde/ do
  Compiler.has?(:pdec).should be_true
end

Given /a source file '(.*)' containing source '(.*)'/ do |file, contents|
  write file, contents
end

Then /the compiler should be identified as pde/ do
  define('foo').compile.compiler.should eql(:pdec)
end

Then /the compiler with custom layout should be identified as pde/ do
  define 'foo', :layout=>@custom_layout do
    compile.compiler.should eql(:pdec)
    test.compile.compiler.should eql(:pdec)
  end
end

When /I define a custom layout for '(.*)' and '(.*)'/ do |src, test|
  @custom_layout[:source, :main, :java] = src
  @custom_layout[:source, :test, :java] = test
end
