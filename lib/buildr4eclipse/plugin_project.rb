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

require "manifest"

module Buildr4Eclipse #:nodoc:
  

  # A module that to add to the Buildr::Project class
  # Projects with that module include can identify themselves as eclipse projects
  module EclipseProject

    def project_id
      name.split(':').last
    end
    
    def version
      raise 'Subclasses must implement'
    end

    def base_directory
      @base_directory unless @base_directory.nil?
      @base_directory = '.'
    end

    def base_directory=(dir)
      @base_directory=dir
    end

  end


  # A module to add to the Buildr::Project class
  # Projects with that module included can auto-resolve their dependencies
  module PluginProject
    
    include EclipseProject

    ECLIPSE_GROUP_ID = "__eclipse"
    
    B_NAME = "Bundle-SymbolicName"
    B_REQUIRE = "Require-Bundle"
    B_VERSION = "Bundle-Version"
    B_DEP_VERSION = "bundle-version"
    B_RESOLUTION = "resolution"
    B_LAZY_START = "Bundle-ActivationPolicy"
    B_OLD_LAZY_START = "Eclipse-LazyStart"
    
    attr_accessor :groupId
    
    # returns an array of the dependencies of the plugin, read from the manifest.
    def autoresolve(add_optionals = true)
      f = File.join(base_dir, "META-INF", "MANIFEST.MF")
      return [] if (!File.exists? f)
      manifest = Manifest.read(File.open(f).read)
      bundles = []
      manifest.first[B_REQUIRE].each_pair {|key, value| bundles << "#{determine_group_id(key.strip)}:#{key.strip}:#{value[B_DEP_VERSION]}" unless "system.bundle" == key || (value[B_RESOLUTION] == "optional" && !add_optionals)} unless manifest.first[B_REQUIRE].nil?
      bundles
    end
    
    def version
      manifest.main["Bundle-Version"]
    end

    def manifest
      manifest = Buildr::Packaging::Java::Manifest.parse(manifest_file.read)
    end
    
    # overrides project's layout to provide a plugin layout
    def layout
      @layout ||= (parent ? parent.layout : Layout.plugin_default).clone
    end
    
    private 
    
    def manifest_file
      File.new(File.expand_path(base_directory, "#{project_id}/META-INF/MANIFEST.MF"))
    end

    # Artifacts that are resolved as dependencies from a manifest don't have a group id. We do the mapping in there.
    def determine_group_id(artifactId)
      return @groupId ? @groupId.call(artifactId) : ECLIPSE_GROUP_ID
    end
    
  end

  module PluginProjectHook
      include Buildr::Extension

      def act_as_eclipse_plugin
        extend Buildr4Eclipse::PluginProject
      end
  end

end

class Buildr::Layout
  class << self
    attr_accessor :plugin_default
  end
  
  class PluginLayout < Layout
    def initialize
      super
        self[:source, :main, :java] = "src"
        self[:source, :main, :resources] = "src"
        
        self[:source, :test, :java] = "../#{plugin_id}.test/src"
        self[:source, :test, :resources] = "../#{plugin_id}.test/src"
    end
  end
end

class Buildr::Project
  include Buildr4Eclipse::PluginProjectHook
end
