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

# require 'spec/expectations'

require 'buildr'
require 'rake'

include Buildr

Then /the compiler should contain pde/ do
  Buildr::Compiler.has?(:pdec).should be_true
end


Given /a source file '(.*)' containing source '(.*)'/ do |file, contents|
  write file, contents
end

Then /^the compiler should be identified as pde/ do
  p define('foo').compile.class
  # define('foo').compile.compiler.should eql(:foo)
end
