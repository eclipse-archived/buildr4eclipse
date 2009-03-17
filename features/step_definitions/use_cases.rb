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

unless defined?(SpecHelpers)
  require File.join(File.dirname(__FILE__), "step_helpers.rb")

  # Defining use cases here so they can be reused throughout the steps

  $eclipse_instances = [File.join(Dir.pwd, "eclipse1"), File.join(Dir.pwd, "eclipse2")]

  Given /^a project identified as a plugin/ do
    @foo_dependencies = ["#{Buildr4Eclipse::ECLIPSE_GROUP_ID}:org.eclipse.core.resources:jar", 
                       "#{Buildr4Eclipse::ECLIPSE_GROUP_ID}:com.ibm.icu:jar"]
    @foo_bar_dependencies = ["#{Buildr4Eclipse::ECLIPSE_GROUP_ID}:com.ibm.icu:jar",
                            "#{Buildr4Eclipse::ECLIPSE_GROUP_ID}:org.eclipse.ui:jar:[3.2.0,4.0.0)"]
    Buildr::write("foo/META-INF/MANIFEST.MF", <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: %pluginName
Bundle-SymbolicName: org.eclipse.stp.bpmn.diagram; singleton:=true
Bundle-Version: 1.1.0.000
Bundle-Activator: org.eclipse.stp.bpmn.diagram.part.BpmnDiagramEditorPlugin
Bundle-Vendor: %providerName
Bundle-Localization: plugin
Eclipse-LazyStart: true
Bundle-RequiredExecutionEnvironment: J2SE-1.5
Require-Bundle: com.ibm.icu,
 org.eclipse.core.resources;visibility:=reexport
MANIFEST
)
    Buildr::write "foo/bar/META-INF/MANIFEST.MF", <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: %pluginName
Bundle-SymbolicName: org.eclipse.stp.bpmn.diagram.bar; singleton:=true
Bundle-Version: 1.1.0.000
Bundle-Activator: org.eclipse.stp.bpmn.diagram.part.BpmnDiagramEditorPlugin
Bundle-Vendor: %providerName
Bundle-Localization: plugin
Eclipse-LazyStart: true
Bundle-RequiredExecutionEnvironment: J2SE-1.5
Require-Bundle: com.ibm.icu,
 org.eclipse.ui;bundle-version="[3.2.0,4.0.0)"
MANIFEST
    Buildr::write "foo/bar2/META-INF/MANIFEST.MF", <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: %pluginName
Bundle-SymbolicName: org.eclipse.stp.bpmn.diagram.bar2; singleton:=true
Bundle-Version: 1.1.0.000
Bundle-Activator: org.eclipse.stp.bpmn.diagram.part.BpmnDiagramEditorPlugin
Bundle-Vendor: %providerName
Bundle-Localization: plugin
Eclipse-LazyStart: true
Bundle-RequiredExecutionEnvironment: J2SE-1.5
MANIFEST
    @project = define('foo', :base_dir => "foo") do
      act_as_eclipse_plugin
      define("bar", :base_dir => "foo/bar") do
        act_as_eclipse_plugin
      end
      define("bar2", :base_dir => "foo/bar2") do
        act_as_eclipse_plugin
      end
      define("bar3", :base_dir => "foo/bar3") do
      end
    end
    @pNotPlugin = define('notPlugin', :base_dir => "notPlugin")
  end

  Given /the user defined one or more Eclipse instances/ do
    ENV['BUILDR_ECLIPSE'] = $eclipse_instances.join(";")
    Buildr::write File.join(File.join(Dir.pwd, "eclipse1"), "plugins/com.ibm.icu-3.9.9.R_20081204/META-INF/MANIFEST.MF"), <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-SymbolicName: com.ibm.icu; singleton:=true
Bundle-Version: 3.9.9.R_20081204
MANIFEST
    Buildr::write File.join(File.join(Dir.pwd, "eclipse1"), "plugins/org.eclipse.core.resources-3.5.0.R_20090512/META-INF/MANIFEST.MF"), <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-SymbolicName: org.eclipse.core.resources; singleton:=true
Bundle-Version: 3.5.0.R_20090512
MANIFEST
    Buildr::write File.join(File.join(Dir.pwd, "eclipse2"), "plugins/org.eclipse.core.resources-3.5.1.R_20090912/META-INF/MANIFEST.MF"), <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-SymbolicName: org.eclipse.core.resources; singleton:=true
Bundle-Version: 3.5.1.R_20090912
MANIFEST
    Buildr::write File.join(File.join(Dir.pwd, "eclipse2"), "plugins/org.eclipse.ui-3.4.2.R_20090226/META-INF/MANIFEST.MF"), <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-SymbolicName: org.eclipse.ui; singleton:=true
Bundle-Version: 3.4.2.R_20090226
MANIFEST
  end

  Given /a plugin '(.*)' with some dependencies '(.*)'/ do |plugin_id, dependencies|
    dependencies = dependencies.split(/\s*,\s*/).join(",\n ")
    manifest = <<-MANIFEST
Bundle-SymbolicName: #{plugin_id}; singleton:=true
Require-Bundle: #{dependencies}
MANIFEST
    Buildr::write "META-INF/MANIFEST.MF", manifest
    @plugin_project = define(plugin_id) do |project|
      act_as_eclipse_plugin
    end
  end

  Given /the plugin with id '(.*)'/ do |plugin_id|
    cp_r "../../test-plugins/#{plugin_id}", Dir.pwd
    @plugin_project = define(plugin_id, :base_dir => File.join(Dir.pwd, plugin_id)) do |project|
      act_as_eclipse_plugin
    end
  end

  Given /a project that should act as a feature/ do
   @p = define('foo') do |project|
      act_as_eclipse_feature
    end
    @pNotFeature = define('bar')
  end
  
  When /the user types "buildr (.*)"/ do |taskName|
    begin
      @task = @project.task(taskName)
    rescue Exception => e
      pending #The exception occurs because the task is not defined yet.
    end
  end
end

