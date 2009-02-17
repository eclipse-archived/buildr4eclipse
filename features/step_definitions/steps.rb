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

$LOAD_PATH.unshift File.expand_path File.join(File.dirname(__FILE__), '../../lib')

require File.dirname(__FILE__) + "/../../buildr/spec/spec_helpers.rb"


# p $LOAD_PATH
require 'buildr4eclipse'

Then /the compiler should contain pde/ do
  Buildr::Compiler.has?(:pdec).should be_true
end

Given /a source file '(.*)' containing source '(.*)'/ do |file, contents|
  Buildr::write file, contents
end

Then /the compiler should be identified as pde/ do
  # p define('foo').compile.class
  Buildr::define('foo').compile.compiler.should eql(:foo)
end
