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
	 When the user asks for it by calling "buildr eclipse:repos"
	 Then Buildr should compute the data from this repository in a file named eclipse_metadata.yaml in the Buildr home directory
	
Scenario: Buildr4eclipse should offer to find artifacts matching a version range
     Given a Buildfile that mentions a special Eclipse repository
     And an artifact that version is actually a range, for example [1.0.0, 2.0.0) 
     When a project tries to resolve that artifact as a dependency to compile against it
     Then it should be possible for the registered eclipse instances to compute a list of the plugins matching that version range
     And they should apply a strategy to select the appropriate artifact

