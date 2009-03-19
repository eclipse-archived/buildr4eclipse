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
# We will be messing up with .jar files that we will treat just like zip files.
require "zip/zip"
require "zip/zipfilesystem"

require File.join(File.dirname(__FILE__), "osgi_bundle")

module Buildr4Eclipse
  
  class OSGiRegistry

    # bundles: the bundles of the eclipse instance loaded on startup
    # location: the location of the Eclipse instance
    attr_accessor :bundles, :location

    # Default constructor for an OSGiRegistry
    # 
    # location: the location of the Eclipse instance
    # plugin_locations, default value is ["dropins", "plugins"] 
    # create_bundle_info, default value is true
    def initialize(location, plugin_locations = ["dropins", "plugins"])
      @location = location
      @bundles = []
      plugin_locations.each do |p_loc|
        p_loc_complete = File.join(@location, p_loc)
        warn "Folder #{p_loc_complete} not found!" if !File.exists? p_loc_complete 
        parse(p_loc_complete) if File.exists? p_loc_complete
      end
    end

    # Parses the directory and grabs the plugins, adding the created bundle objects to @bundles.
    def parse(dir)
      Dir.open(dir) do |plugins|
        plugins.entries.each do |plugin|
          absolute_plugin_path = "#{plugins.path}#{File::SEPARATOR}#{plugin}"
          if (/.*\.jar$/.match(plugin)) 
            zipfile = Zip::ZipFile.open(absolute_plugin_path)
            entry =  zipfile.find_entry("META-INF/MANIFEST.MF")
            if (entry != nil)
              manifest = Manifest.read(zipfile.read("META-INF/MANIFEST.MF"))
              @bundles << OSGiBundle.fromManifest(manifest, absolute_plugin_path) 
            end
            zipfile.close
          else
            # take care of the folder
            if (File.directory?(absolute_plugin_path) && !(plugin == "." || plugin == ".."))
              if (!File.exists? ["#{absolute_plugin_path}", "META-INF", "MANIFEST.MF"].join(File::SEPARATOR))
                #recursive approach: we have a folder wih no MANIFEST.MF, we should look into it.
                parse(absolute_plugin_path)
              else
                next if File.exists? "#{absolute_plugin_path}/feature.xml" # avoid parsing features.
                begin
                  manifest = Manifest.read((file = File.open("#{absolute_plugin_path}/META-INF/MANIFEST.MF")).read)
                rescue
                  file.close
                end
                @bundles << OSGiBundle.fromManifest(manifest, absolute_plugin_path)
              end
            end
          end
        end
      end
    end
    
    # Return the list of bundles that match the criteria passed as arguments
    def find(criteria = {:name => "", :version =>""})
      selected = bundles
      if (criteria[:name])
        selected = selected.select {|b| b.name == criteria[:name]}
      end
      if (criteria[:version])
        selected = selected.select {|b| b.version == criteria[:version]}
      end
      selected
    end

  end

end