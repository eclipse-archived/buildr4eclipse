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

Feature: The Eclipse feature project

Scenario: Buildr4eclipse should give the ability for a project to be identified as a feature
    Given a project that should act as a feature
    Then Buildr4eclipse should add a set of attributes and methods to help package the feature

Scenario: Buildr4eclipse should have the ability to generate a feature
	Given a project identified as a feature, packaging plugins
	Then Buildr4eclipse should bundle the plugins and generate the feature accordingly
