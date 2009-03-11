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

# The Eclipse instance is a special kind of repository that is bound to an Eclipse instance.
# By itself, an Eclipse instance doesn't know what it contains.
# Since its content may evolve over time, an Eclipse instance may need to recompute its artifacts metadata.

module Buildr4eclipse
  
  module EclipseInstance
    
    ECLIPSE_GROUP_ID = "__eclipse"
    
    attr_accessor :eclipse_instance
    def eclipse_instance=(instances)
      case instances
      when nil then @eclipse_instance = nil
      when Array then @eclipse_instance = instances.dup
      else @eclipse_instance = [instances.to_s]
      end
    end
    
    def eclipse_instance
      unless @eclipse_instance
        @eclipse_instance = [Buildr.settings.user, Buildr.settings.build].inject([]) { |repos, hash|
          repos | Array(hash['repositories'] && hash['repositories']['eclipse_instance'])
        }
      end
      @eclipse_instance
    end
    
    def _locate(spec)
      spec = Artifact.to_hash(spec)
      if (spec[:group] == ECLIPSE_GROUP_ID)
        return locate_within_eclipse_instances(spec)
      end
      File.join(local, spec[:group].split('.'), spec[:id], spec[:version], Artifact.hash_to_file_name(spec))
    end
    
    protected
    
    def locate_within_eclipse_instances(spec)
      if (@eclipse_instance)
        @eclipse_instance.each do |instance|
          plugin = File.join(instance, "plugins/#{spec[:id]}_#{spec[:version]}.jar")
          return plugin if File.exists? plugin
        end
      end
    end
  end
  
  Buildr::Repositories.class_eval do
    include EclipseInstance
    alias :locate :_locate
  end
  
end