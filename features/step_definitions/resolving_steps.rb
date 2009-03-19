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

Then /the compiler should be able to guess dependencies '(.*)' by looking at the manifest/ do |dependencies|
  bundles = @plugin_project.manifest_dependencies

  dependencies.split(/\s*,\s*/).each do |dependency|
    foundIt = false
    bundles.each do |b|
      if (dependency == b.name)
        foundIt = true
        break
      end
    end
    foundIt.should be_true
  end
end

When /the project resolves dependencies over version ranges/ do
  @dependencies = @project.project("foo:bar").manifest_dependencies
end

Then /^it should be possible for the registered eclipse instances to compute a list of the plugins matching the version range of each dependency$/ do
  @deps_w_resolved_artifacts = {}
  @dependencies.each do |d|
    @deps_w_resolved_artifacts[d] = d.resolve_matching_artifacts
  end
end

Then /^they should apply a strategy to select the appropriate artifact: :latest, :prompt, or a custom strategy$/ do
  eclipse.resolving_strategy = :latest
  eclipse.resolving_strategy.should == :latest
  @deps_w_resolved_artifacts.each_pair {|key, resolved_bundles| 
    if key.name == "org.eclipse.ui"
      resolved = key.resolve! resolved_bundles
      resolved.should_not be_nil
      resolved.version.should == "3.5.0.M_20090107"
    end
  }
  
  eclipse.resolving_strategy = :oldest
  eclipse.resolving_strategy.should == :oldest
  @deps_w_resolved_artifacts.each_pair {|key, resolved_bundles| 
    if key.name == "org.eclipse.ui"
      resolved = key.resolve! resolved_bundles
      resolved.version.should == "3.4.2.R_20090226"
    end
  }
  
  eclipse.resolving_strategy = :prompt
  eclipse.resolving_strategy.should == :prompt
  @deps_w_resolved_artifacts.each_pair {|key, resolved_bundles| 
    if key.name == "org.eclipse.ui"
      gets "1" #prepare the user input
      lambda {resolved = key.resolve!(resolved_bundles)
        resolved.version.should == "3.4.2.R_20090226"
      }.should show(["Choose a bundle amongst those presented:\n\t1. org.eclipse.ui 3.4.2.R_20090226\n\t2. org.eclipse.ui 3.5.0.M_20090107"])
      
    end
  }
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