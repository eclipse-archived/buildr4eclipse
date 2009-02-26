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

class Buildr::Layout
  class << self
    attr_accessor :plugin_default
  end
  
  class PluginLayout < Layout
    def initialize(*plugin_id)
      super()
        self[:source, :main, :java] = "#{plugin_id}/src"
        self[:source, :main, :resources] = "#{plugin_id}/src"
        
        self[:source, :test, :java] = "../#{plugin_id}.test/src"
        self[:source, :test, :resources] = "../#{plugin_id}.test/src"
    end
  end
end

