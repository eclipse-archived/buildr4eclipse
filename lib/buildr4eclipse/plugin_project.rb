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
  
  # A module to add to the Buildr::Project class
  # Projects with that module included can auto-resolve their dependencies
  module PluginProject
    include Manifest
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
      manifest = read(File.open(f).read)
      bundles = []
      manifest.first[B_REQUIRE].each_pair {|key, value| bundles << "#{determine_groupId(key.strip)}:#{key.strip}:#{value[B_DEP_VERSION]}" unless "system.bundle" == key || (value[B_RESOLUTION] == "optional" && !add_optionals)} unless manifest.first[B_REQUIRE].nil?
      bundles
    end
    
    private 
    
    # Artifacts that are resolved as dependencies from a manifest don't have a group id. We do the mapping in there.
    def determine_groupId(artifactId)
      return @groupId ? @groupId.call(artifactId) : ECLIPSE_GROUP_ID
    end
    
  end
end

class Buildr::Project
  include Buildr4Eclipse::PluginProject
end