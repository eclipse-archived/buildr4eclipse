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
    
    attr_accessor :name, :version, :optional, :group
    
    def initialize
      @group = Buildr4Eclipse::ECLIPSE_GROUP_ID 
    end
    
    def self.from_spec(spec)
      bundle = OSGiBundle.new
      bundle.name = spec[:name]
      # Either a range or a version: we find out by trying to parse
      bundle.version = VersionRange.parse(spec[:version])
      # If the parsing returned false, we initialize with the string
      bundle.version ||= spec[:version]
      bundle.optional = spec[:optional]
      bundle.group = spec[:group] if spec[:group]
      return bundle
    end
    
    def to_s
      Buildr::Artifact.to_spec({:group => group, :id => name, :type => "jar", :version => version})
    end
    
    def resolve_matching_artifacts
      if version.is_a? VersionRange
        return Buildr4Eclipse::EclipseInstance::Instance.instance.resolved_instances.collect {|i| 
          i.find(:name => name).select {|b| version.in_range(b.version)}}.flatten.compact.collect{|b| 
            osgi = OSGiBundle.new
            osgi.name = b.name
            osgi.version = b.version
            osgi.optional = optional
            osgi.group = group
            osgi}
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