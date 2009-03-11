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
	Then the layout should be of type 'Buildr::Layout::PluginLayout'

Scenario: should be able to package a plugin as a jar
	Given the plugin with id 'com.foo.calculator.plugin'
	When the plugin is compiled using jdt compiler
	Then the plugin should be packaged as a plugin jar

Scenario: Buildr4eclipse should let projects auto-resolve dependencies
	Given a plugin 'org.foo.has.dependencies' with some dependencies 'com.foo.plugin, com.bar.plugin'
	Then the compiler should be able to guess dependencies 'com.foo.plugin, com.bar.plugin' by looking at the manifest

Scenario: Buildr4eclipse should associate with an Eclipse instance
    Given a plugin project
    When an Eclipse instance is defined 
    Then the project should be able to associate with it

Scenario: Buildr4eclipse should find all the dependencies of a project transitively
    Given a plugin with some dependencies
    When the plugin is asked to compile by auto-resolving its dependencies
    Then it should be able to find all its dependencies and match them to actual artifacts
