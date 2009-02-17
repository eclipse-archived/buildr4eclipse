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

def create_includes(project, plugin_id)
  inc = get_includes(project)
  
  inc.collect! do |file|
    raise "Could not find file/directory '#{file}' defined in the build.properties of '#{plugin_id}'" if !File.exists?(project._(file))
    project._(file)
  end
end

def get_includes(project)
  project_build_properties(project)['bin.includes'].split(',') - ['.']
end

def project_build_properties(project)
  load_properties(project._('build.properties'))
end
 
def load_properties(properties_filename)
  Hash.from_java_properties File.new(properties_filename).read
end

#
# Create a custom manifest by replacing the 'qualifier' in the 'Bundle-Version' property.
#
def create_manifest(plugin_id)
  manifest = Buildr::Packaging::Java::Manifest.parse(File.new("#{plugin_id}/META-INF/MANIFEST.MF").read)
  manifest.main["Bundle-Version"].gsub! /qualifier/, VERSION_NUMBER
  manifest
end

def plugin_version(plugin_id)
  manifest = Buildr::Packaging::Java::Manifest.parse(File.new("#{plugin_id}/META-INF/MANIFEST.MF").read)
  manifest.main["Bundle-Version"].gsub /qualifier/, VERSION_NUMBER  
end

def create_layout(plugin_id)
	my_layout = Layout.new
	my_layout[:source, :main, :java] = "src"
	my_layout[:source, :main, :resources] = "src"
	
	my_layout[:source, :test, :java] = "../#{plugin_id}.test/src"
	my_layout[:source, :test, :resources] = "../#{plugin_id}.test/src"
	return my_layout
end
