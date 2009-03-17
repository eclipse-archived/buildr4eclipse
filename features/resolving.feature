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

Feature: Resolving dependencies from the manifest, using Eclipse to get exact version matches

Scenario: Buildr4eclipse should let projects resolve dependencies
	Given a plugin 'org.foo.has.dependencies' with some dependencies 'com.foo.plugin, com.bar.plugin'
	Then the compiler should be able to guess dependencies 'com.foo.plugin, com.bar.plugin' by looking at the manifest
	
Scenario: Buildr4eclipse should offer to find artifacts matching a version range
	Given a Buildfile that mentions a special Eclipse repository
	And a project depends over an artifact by specifying its version through a range, for example [1.0.0, 2.0.0) 
	When a project tries to resolve that artifact as a dependency while resolving it for Maven integration
	Then it should be possible for the registered eclipse instances to compute a list of the plugins matching that version range
	And they should apply a strategy to select the appropriate artifact: :latest, :prompt, or a custom strategy
	
Scenario: Buildr4eclipse should offer a task that finds the dependencies, pushes them to dependencies.rb and the local maven repo, and finally uploads them
	Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
	When the user types "buildr eclipse:resolve:all[http://www.example.com/maven]"
    Then the dependencies of the project should be listed in a file named dependencies.rb next to the buildfile
	And dependencies.yml should contain a yaml description of the dependencies, organized by subproject
	And the artifacts the project depends on, ie the jar files or a jar'ed version of the directories should be copied to the local maven repository
	And they should all use the group id "eclipse"
	And the artifacts the project depends on, ie the jar files or a jar'ed version of the directories present in the local repository should be uploaded to http://www.example.com/maven