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
      class EclipseJarTask < JarTask
        def initialize(*args)
          super
          compression_level = Zlib::BEST_COMPRESSION
        end
      end

      # Package the project as a plugin
      def package_as_plugin(file_name)
        EclipseJarTask.define_task(file_name).tap do |jar|
          jar.with :manifest => manifest, :meta_inf=>meta_inf, :compression_level =>Zlib::BEST_COMPRESSION
          jar.with [compile.target, resources.target].compact
        end
      end
      
      # Package the project as a feature
      def package_as_feature(file_name)
        EclipseJarTask.define_task(file_name).tap do |jar|
          jar.with "eclipse/plugins", "eclipse/features", :meta_inf=>meta_inf, :compression_level =>Zlib::BEST_COMPRESSION
        end
      end
    end
  end
end
