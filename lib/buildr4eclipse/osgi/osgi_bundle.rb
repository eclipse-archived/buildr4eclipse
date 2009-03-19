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
  
  class Version
    
    attr_accessor :major, :minor, :tiny, :qualifier
    
    def initialize(string)
      digits = string.split(".")
      @major = digits[0]
      @minor = digits[1]
      @tiny = digits[2]
      @qualifier = digits[3]
      raise "Invalid version: " + self.to_s if @major.nil?
    end
    
    def to_s
      [major, minor, tiny, qualifier].compact.join(".")
    end
    
    def <=>(other)
      if other.is_a? String
        other = Version.new(other)
      elsif other.nil?
        return 1
      end
      
      [:major, :minor, :tiny, :qualifier].each do |digit|
        return 0 if send(digit).nil? 
  
        comparison = send(digit) <=> other.send(digit)
        if comparison != 0
          return comparison
        end
          
      end
      return 0
    end
    
    def <(other)
      (self.<=>(other)) == -1
    end
    
    def >(other)
      (self.<=>(other)) == 1
    end
    
    def ==(other)
      (self.<=>(other)) == 0
    end
    
    def <=(other)
      (self.==(other)) || (self.<(other))
    end
    
    def >=(other)
      (self.==(other)) || (self.>(other))
    end
  end
  
  class VersionRange
    
    attr_accessor :min, :max, :min_inclusive, :max_inclusive
    
    def self.parse(string)
      if !string.nil? && (match = string.match /\s*([\[|\(])(.*),(.*)([\]|\)])/)
        range = VersionRange.new
        range.min = Version.new(match[2])
        range.max = Version.new(match[3])
        range.min_inclusive = match[1] == '['
        range.max_inclusive = match[4] == ']'
        range
      else
        false
      end
    end
    
    def to_s
      "#{ min_inclusive ? '[' : '('}#{min},#{max}#{max_inclusive ? ']' : ')'}"
    end
    
    def in_range(version)
      (min_inclusive ? min <= version : min < version) && (max_inclusive ? max >= version : max > version)
    end
  end
  
  class OSGiBundle
    
    #Keys used in the MANIFEST.MF file
    B_NAME = "Bundle-SymbolicName"
    B_REQUIRE = "Require-Bundle"
    B_VERSION = "Bundle-Version"
    B_DEP_VERSION = "bundle-version"
    B_RESOLUTION = "resolution"
    B_LAZY_START = "Bundle-ActivationPolicy"
    B_OLD_LAZY_START = "Eclipse-LazyStart"

    # Attributes of a bundle, derived from its manifest
    # The name is always the symbolic name
    # The version is either the exact version of the bundle or the range in which the bundle would be accepted.
    # The file is the location of the bundle on the disk
    # The optional tag is present on bundles resolved as dependencies, marked as optional.
    # The start level is deduced from the bundles.info file. Default is -1.
    # The lazy start is found in the bundles.info file
    attr_accessor :name, :version, :bundles, :file, :optional, :start_level, :lazy_start, :group
    def initialize(name, version, file=nil, bundles=[], optional = false)
      @name = name
      @version = VersionRange.parse(version)
      @version ||= version
      @bundles = bundles
      @file = file
      @optional = optional
      @start_level = 4
      @group = Buildr4Eclipse::ECLIPSE_GROUP_ID 
    end
    
    # Creates itself by loading from the manifest file passed to it as a hash
    # Finds the name and version, and populates a list of dependencies.
    def self.fromManifest(manifest, jarFile) 
      bundles = []
      #see http://aspsp.blogspot.com/2008/01/wheres-system-bundle-jar-file-cont.html for the system.bundle trick.
      #key.strip: sometimes there is a space between the comma and the name of the bundle.
      manifest.first[B_REQUIRE].each_pair {|key, value| bundles << Bundle.new(key.strip, value[B_DEP_VERSION], nil, [], value[B_RESOLUTION] == "optional") unless "system.bundle" == key} unless manifest.first[B_REQUIRE].nil?
      bundle = OSGiBundle.new(manifest.first[B_NAME].keys.first, manifest.first[B_VERSION].keys.first, jarFile, bundles)
      if !manifest.first[B_LAZY_START].nil? 
        # We look for the value of Bundle-ActivationPolicy: lazy or nothing usually. 
        # lazy may be spelled Lazy too apparently, so we downcase the string in case.
        bundle.lazy_start = "lazy" == manifest.first[B_LAZY_START].keys.first.strip.downcase
      else
        bundle.lazy_start = "true" == manifest.first[B_OLD_LAZY_START].keys.first.strip unless manifest.first[B_OLD_LAZY_START].nil?
      end
      if (bundle.lazy_start)
        bundle.start_level = 4
      else
        bundle.start_level = -1
      end
      return bundle
    end
    
    def to_s
      Buildr::Artifact.to_spec({:group => group, :id => name, :type => "jar", :version => version})
    end
    
    def resolve_matching_artifacts
      if version.is_a? VersionRange
        return Buildr4Eclipse::EclipseInstance::Instance.instance.resolved_instances.collect {|i| 
          i.find(:name => name).select {|b| version.in_range(b.version)}}.flatten.compact.collect{|b| 
            osgi = OSGiBundle.new(b.name, b.version)
            osgi.optional = optional
            osgi.group = group
            osgi
          }
      end
      [self]
    end
    
    def resolve(bundles = resolve_matching_artifacts)
      osgi = OSGiBundle.new
      osgi.name = name
      osgi.version = version
      osgi.optional = optional
      osgi.group = group
      osgi.resolve!(bundles)
      osgi
    end
    
    def resolve!(bundles = resolve_matching_artifacts)
      case bundles.size
      when 0
        return nil
      when 1
        return bundles[0]
      else
        strategy = Buildr4Eclipse::EclipseInstance::Instance.instance.resolving_strategy
        case strategy
        when Symbol
          return Buildr4Eclipse::ResolvingStrategies.send(strategy, bundles)
        when Block
          return resolving_strategy.call(bundles)
        end
      end
    end
    
  end
end