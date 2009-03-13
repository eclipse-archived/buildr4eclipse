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

Feature: The PDE compiler
  
  Scenario: Should be in the compilers list
    Then the compiler should contain pde

  Scenario: Should identify pde compiler from source directory structure
    Given a source file 'src/main/java/com/example/Test.java' containing source 'package com.example; class Test {}'
    Then the compiler should be identified as pde

  Scenario: Should identify from source directories using custom layout
    Given a source file 'src/main/java/com/example/Test1.java' containing source 'package com.example; class Code {}'
    And a source file 'testing/com/example/Test.java' containing source 'package com.example; class Test {}' 
    When I define a custom layout for 'src' and 'testing'
    Then the compiler with custom layout should be identified as pde

  Scenario: The compiler should compile according to the Export-Package entries in the plugin
    Given a plugin that exports some of its packages using the Export-Package entry in its manifest
    And a second project that depends on a class that is present in a non-exported package
    When the compiler attempts to compile that second project
    Then the compiler should issue a warning by default.

  Scenario: The compiler should be configurable by users
    Given a plugin that exports some of its packages using the Export-Package entry in its manifest
    And a second project that depends on a class that is present in a non-exported package
    When the option (?) is set to the level of error
    Then the project compilation should fail because of the error reported on the dependency over a non-exported package