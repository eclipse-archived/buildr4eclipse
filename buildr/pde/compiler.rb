module Buildr
  
  module Compiler
    
    class PDEc < Base
      require "jdtc"
      include Jdtc
      
      OPTIONS = [:warnings, :debug, :deprecation, :source, :target, :lint, :other]
    
      specify :language=>:java, :sources => 'java', :source_ext => 'java',
              :target=>'classes', :target_ext=>'class', :packaging=>:plugin
    
      class << self
        def applies_to?(project, task) #:nodoc:
          paths = task.sources + [sources].flatten.map { |src| Array(project.path_to(:source, task.usage, src.to_sym)) }
          paths.flatten!
          # Just select if we find .java files and a plugin manifest
          paths.any? { |path| !Dir["#{path}/**/*.java"].empty? }
        end
      end
    
      def initialize(project, options) #:nodoc:
        super
        options[:debug] = Buildr.options.debug if options[:debug].nil?
        options[:warnings] = verbose if options[:warnings].nil?
        options[:deprecation] ||= false
        options[:lint] ||= false
      end

      def compile(sources, target, dependencies) #:nodoc:
        
        copy_non_src_files(sources, target)    
            
        check_options options, OPTIONS
        cmd_args = []
        # tools.jar contains the Java compiler.
        dependencies << Java.tools_jar if Java.tools_jar
        cmd_args << '-classpath' << dependencies.join(File::PATH_SEPARATOR) unless dependencies.empty?
        source_paths = sources.select { |source| File.directory?(source) }
        cmd_args << '-sourcepath' << source_paths.join(File::PATH_SEPARATOR) unless source_paths.empty?
        cmd_args << '-d' << File.expand_path(target)
        cmd_args += javac_args
        cmd_args += files_from_sources(sources)
        unless Buildr.application.options.dryrun
          jdtc(cmd_args) == 0 or
            fail 'Failed to compile, see errors above'
        end
      end

    private

      def copy_non_src_files(sources, target)
        sources.each do |src_dir|
          FileList["#{sources}/**/*"].exclude("*.java").each do |source|
            relative = source.sub(src_dir, "").sub("/", "")
            cp_r source,File.join(target, relative), :verbose=>false
          end
        end
      end
      
      def javac_args #:nodoc:
        args = []  
        args << '-nowarn' unless options[:warnings]
        args << '-verbose' if Buildr.application.options.trace
        args << '-g' if options[:debug]
        args << '-deprecation' if options[:deprecation]
        args << '-source' << options[:source].to_s if options[:source]
        args << '-target' << options[:target].to_s if options[:target]
        case options[:lint]
          when Array  then args << "-Xlint:#{options[:lint].join(',')}"
          when String then args << "-Xlint:#{options[:lint]}"
          when true   then args << '-Xlint'
        end
        args + Array(options[:other])
      end

      alias :pdec_args :javac_args 
    end
  end
  
  class Artifact
    class << self 
      def hash_to_file_name(hash)
        if hash[:type] == :plugin 
          return hash[:id].sub("#{hash[:group]}-", "") + "_#{hash[:version]}.jar"
        else
          version = "-#{hash[:version]}" if hash[:version]
          classifier = "-#{hash[:classifier]}" if hash[:classifier]
          return "#{hash[:id]}#{version}#{classifier}.#{hash[:type] || DEFAULT_TYPE}"
        end
      end
    end
  end
end

Buildr::Compiler << Buildr::Compiler::PDEc
