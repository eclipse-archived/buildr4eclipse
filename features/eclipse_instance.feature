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
     Then it should be associated with the other repositories for artifact resolution
     
Scenario: Buildr4eclipse should define a task to store the local metadata of the Eclipse instance repository
     Given a Buildfile that is bound to an Eclipse instance repository
     When the user asks for it by calling "buildr eclipse:repos"
     Then Buildr should give the ability to compute the data from this repository in a file named .repo_metadata at the root of the Eclipse instance