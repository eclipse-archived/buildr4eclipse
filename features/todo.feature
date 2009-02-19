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


Feature: TODO
  Scenario: Buildr4eclipse should let projects auto-resolve dependencies
    Given a plugin with some dependencies
    Then the compiler should be able to guess them by looking at the manifest
            
  Scenario: Buildr4eclipse should have the ability to generate a feature
    Given a project identified as a feature, packaging plugins
    Then Buildr4eclipse should bundle the plugins and generate the feature accordingly

  Scenario: Buildr4eclipse should have the ability to generate a p2 update site
    Given a project identified as a site, packaging plugins or features
    Then Buildr4eclipse should bundle the plugins and generate the site accordingly

