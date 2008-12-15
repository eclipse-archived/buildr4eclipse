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
