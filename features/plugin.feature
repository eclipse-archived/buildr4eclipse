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

Feature: The Eclipse plugin project

Scenario: Buildr4eclipse should give the ability for a project to be identified as a plugin
    Given a project that should act as a plugin
    Then Buildr4eclipse should add a set of attributes and methods to help package the plugin

Scenario: should be able to set the correct layout for a plugin project
	Given a project that should act as a plugin
	Then the layout should be of type 'PluginLayout'

Scenario: should be able to package a plugin as a jar
	Given the plugin with id 'com.foo.calculator.plugin'
	When the plugin is compiled using jdt compiler
	Then the plugin should be packaged as a plugin jar