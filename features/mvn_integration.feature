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

Feature: Maven integration with Buildr4eclipse

Scenario: Buildr4eclipse should offer a task to push the dependencies of a project from Eclipse instances into the local maven repository
   Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
   When the user types "buildr eclipse:resolve:maven"
   Then the artifacts the project depends on, ie the jar files or a jar'ed version of the directories should be copied to the local maven repository
   And they should all use the group id "eclipse" by default or let the user decide

Scenario: Buildr4eclipse should offer a task to upload the project dependencies from the local Maven repository to a remote repository if they are not already present there
   Given a project identified as a plugin with plugin dependencies, with at least one Eclipse instance registered
   When the user types "buildr eclipse:resolve:maven_upload[http://www.example.com/maven]"
   Then the artifacts the project depends on, ie the jar files or a jar'ed version of the directories present in the local repository should be uploaded to http://www.example.com/maven