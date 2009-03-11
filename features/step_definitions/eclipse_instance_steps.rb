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
   
Then /it should be associated with the other repositories for artifact resolution/ do
  p = repositories.locate("__eclipse:org.something:jar:1.0.0.M456")
  p.match(Dir.pwd + "/eclipse").should_not be_nil
end
   
Given /a Buildfile that is bound to an Eclipse instance repository/ do
  pending
end

When /the user asks for it by calling "buildr eclipse:repos"/ do
  pending
end
   
Then /Buildr should give the ability to compute the data from this repository in a file named .repo_metadata at the root of the Eclipse instance/ do
  pending
end
     

     