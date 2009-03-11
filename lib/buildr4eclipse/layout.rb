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

module Buildr4Eclipse
  
  class PluginLayout < Layout
    def initialize(*plugin_id)
      super()
      self[:source, :main, :java] = "src"
      self[:source, :main, :resources] = "src"

      self[:source, :test, :java] = "../#{plugin_id}.test/src"
      self[:source, :test, :resources] = "../#{plugin_id}.test/src"

      self[:target] = "bin"
      self[:target, :main] = "bin"

      self[:target, :main, :classes] = "bin"
      self[:target, :main, :resources] = "bin"

      self[:target, :test] = "../#{plugin_id}.test/bin"

      self[:target, :test, :classes] = "../#{plugin_id}.test/bin"
      self[:target, :test, :resources] = "../#{plugin_id}.test/bin"
    end
  end
end

