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
