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

Feature: The Eclipse instance repository

Scenario: Buildr4eclipse should define a special type of local repository bound to an Eclipse instance
     Given a Buildfile that mentions a special Eclipse repository
     When an artifact has a special group identifier, say "__eclipse"
     Then the artifact should be located in the Eclipse instance repositories

Scenario: Buildr4eclipse should define a task to store the local metadata of the Eclipse instance repository
	 Given a Buildfile that mentions a special Eclipse repository
	 When the user types "buildr eclipse:repos"
	 Then Buildr should compute the data from this repository in a file named eclipse_metadata.yaml in the Buildr home directory

Scenario: Buildr4eclipse should offer a task to resolve the dependencies in a file named dependencies.rb next to the buildfile
   Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
   When the user types "buildr eclipse:autoresolve:dependencies"
   Then the dependencies of the project should be listed in a file named dependencies.rb next to the buildfile
   And that file should contain a yaml description of the dependencies, organized by subproject

Scenario: Buildr4eclipse should offer to find artifacts matching a version range
     Given a Buildfile that mentions a special Eclipse repository
     And a project depends over an artifact by specifying its version through a range, for example [1.0.0, 2.0.0) 
     When a project tries to resolve that artifact as a dependency to compile against it
     Then it should be possible for the registered eclipse instances to compute a list of the plugins matching that version range
     And they should apply a strategy to select the appropriate artifact

Scenario: Buildr4eclipse should offer a task to push the dependencies of a project from Eclipse instances into the local maven repository
   Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
   When the user types "buildr eclipse:autoresolve:maven"
   Then the artifacts the project depends on, ie the jar files or a jar'ed version of the directories should be copied to the local maven repository
   And they should all use the group id "eclipse"

Scenario: Buildr4eclipse should offer a task to upload the project dependencies from the local Maven repository to a remote repository if they are not already present there
   Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
   When the user types "buildr eclipse:autoresolve:maven_upload http://www.example.com/maven"
   Then the artifacts the project depends on, ie the jar files or a jar'ed version of the directories present in the local repository should be uploaded to http://www.example.com/maven

Scenario: Buildr4eclipse should add the missing plugins to an Eclipse instance for the purpose of developing a plugin through a task
   Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
   When the user types "buildr eclipse:add_missing_dependencies ~/eclipse"
   Then the missing plugin dependencies in the Eclipse instance should be copied to the dropins folder

Scenario: Buildr4eclipse should offer a task to generate the Eclipse project files according to the buildfile
  Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
  When the user types "buildr eclipse"
  Then the .classpath and .project files should be generated for the project
	