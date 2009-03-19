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
  Given "the user defined one or more Eclipse instances"
  ENV[var] = @eclipse_instances.join(";")
end

When /the user defines Eclipse instances in his buildr settings under the key (.*)/ do |settings_key|
  Given "the user defined one or more Eclipse instances"
  Buildr::write 'home/.buildr/settings.yaml', {"eclipse" => { "instances" => @eclipse_instances}}.to_yaml
end

Then /Buildr4eclipse should be aware of the Eclipse instances defined on the user system/ do
  Buildr.eclipse.instances.should == @eclipse_instances
end
     