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

module Buildr4Eclipse #:nodoc:
  
  # A module to add to the Buildr::Project class
  # Projects with that module included can auto-resolve their dependencies
  module FeatureProject

    include EclipseProject

    attr_accessor :label, :provider_name, :changes_url, :description, :copyright, :license_url, :license
    
    attr_reader :update_urls, :discovery_urls
    
    def update_urls(label, url)
      @update_urls ||= []
      @update_urls << {:label => label, :url => url}
    end
    
    def discovery_urls(label, url)
      @discovery_urls ||= []
      @discovery_urls << {:label => label, :url => url}
    end
    
    #Returns the content of the feature.xml file for the current feature
    def feature_xml(id, version, plugins = [])
      builder = Builder::XmlMarkup.new
      builder.feature(:id => id, :label => @label, :version => version, :"provider-name" => @provider_name) {|feature| 
        feature.description({:url => @changes_url}, @provider_name)
        feature.copyright @copyright
        feature.license({:url => @license_url}, @license)
        if (@update_urls || @discovery_urls)
          feature.url {|url|
            @update_urls.each do |update|
              url.update({:label => update[:label], :url => update[:url]})
            end unless !@update_urls
            @discovery_urls.each do |discovery|
              url.discovery({:label => discovery[:label], :url => discovery[:url]})
            end unless !@discovery_urls
          }
        end
        
        if (plugins)
          plugins.each do |plugin|
            feature.plugin({:id => plugin[:id], :version => plugin[:version], :"download-size" => plugin[:"download-size"], :"install-size" => plugin[:"install-size"], "unpack" => plugin[:unpack]})  
          end 
        end
      }
    end
    
  end

  # A hook to add dynamically the feature methods and attributes to projects that have the :feature nature
  module FeatureProjectHook
      include Buildr::Extension   
      
      def act_as_eclipse_feature
        extend Buildr4Eclipse::FeatureProject
      end
  end
end

class Buildr::Project
  include Buildr4Eclipse::FeatureProjectHook
end
