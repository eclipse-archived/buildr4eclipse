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

module Buildr
  module Packaging
    module Java
      class PluginJarTask < JarTask
        def initialize(*args)
          super
          compression_level = Zlib::BEST_COMPRESSION
        end
      end

      def package_as_plugin(file_name) #:nodoc:
        PluginJarTask.define_task(file_name).tap do |jar|
		      plugin_id = project.name.split(':').last
          jar.with :manifest => create_manifest(plugin_id), :meta_inf=>meta_inf, :compression_level =>Zlib::BEST_COMPRESSION
          jar.with [compile.target, resources.target].compact
        end
      end
    end
  end
end
