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
module Buildr4Eclipse
  
  module EclipseInstance
  
    # EclipseInstances
    #
    # A class available as a singleton on the Buildr object
    # representing the Eclipse instances available for Buildr
    #
    class Instance
      include Singleton
    
      # instances
      #
      # Returns a list of instances read from the environment variable BUILDR_ECLIPSE
      # or set in the buildr settings under eclipse/instances.
      def instances
        unless @instances # in case we add a way to set instances at some point.
          @instances = [Buildr.settings.user, Buildr.settings.build].inject([]) { |repos, hash|
            repos | Array(hash['instances'] && hash['eclipse']['instances'])
          }
          if ENV['BUILDR_ECLIPSE'] 
            @instances |= ENV['BUILDR_ECLIPSE'].split(';')
          end
        end
        @instances
      end
    
      # resolved_instances
      #
      # Resolves the current instances and returns an array of the instances
      # 
      def resolved_instances
        unless @resolved_instances
          @resolved_instances = instances.collect { |instance|
            Rprov::EclipseInstance.new(instance) 
          }
        end
        @resolved_instances
      end
    end
  end


  class DependenciesTask < Rake::Task

    attr_accessor :project
    
    def initialize(*args) #:nodoc:
      super
 
      enhance do |task|
        dependencies = {}
        project.projects.select { |subp| subp.respond_to? :manifest_dependencies }.each do |subp|
          subp_deps = subp.manifest_dependencies
          dependencies[subp.name] = subp_deps.collect {|dep| dep.to_s } unless subp_deps.empty?
        end
        
        if (project.respond_to? :manifest_dependencies)
          project_deps = project.manifest_dependencies
          dependencies[project.name] = project_deps.collect {|dep| dep.to_s } unless project_deps.empty?
        end
        Buildr::write File.join(project.base_dir, "dependencies.yml"), dependencies.to_yaml
      end
    end
  end
  
  # Methods added to Project for compiling, handling of resources and generating source documentation.
  module EclipseDependencies

    include Extension

    first_time do
      desc 'Evaluate Eclipse dependencies and places them in dependencies.rb'
      Project.local_task('eclipse:resolve:dependencies') { |name| "Resolving dependencies for #{name}" }
    end
    
    before_define do |project|
      dependencies = DependenciesTask.define_task('eclipse:resolve:dependencies')
      dependencies.project = project
    end
    
    def dependencies(&block)
      task('eclipse:resolve:dependencies').enhance &block
    end
  end
end

# Hook into Buildr and add the eclipse_instances method
module Buildr
  # :call-seq:
  #    eclipse_instances => EclipseInstances.instance.instances
  #
  # Returns the list of Eclipse instances
  #
  # See EclipseInstances.
  def eclipse_instances
    Buildr4Eclipse::EclipseInstance::Instance.instance.instances
  end
  
  class Project
    include Buildr4Eclipse::EclipseDependencies
  end
end