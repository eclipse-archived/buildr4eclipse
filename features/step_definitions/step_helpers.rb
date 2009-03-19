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


# Point to the buildr source to run with Buildr's source. 

# Load once, test everywhere ?
unless defined?(SpecHelpers)

  require "spec/mocks"
  require 'ruby-debug'
  Debugger.start

  $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '../../lib'))

  # See https://issues.apache.org/jira/browse/BUILDR-266
  # We keep the puts method, load SpecHelpers, and we put back puts.
  Cucumber::Broadcaster.class_eval do
    alias :safe_puts :puts
  end

  require File.join(File.dirname(__FILE__), "/../../buildr/spec/spec_helpers.rb")

  
  Cucumber::Broadcaster.class_eval do
    alias :puts :safe_puts
  end

  require 'buildr4eclipse'

  World do |world|
    world.extend(Buildr)
    world.extend(SpecHelpers)
    world.extend(Sandbox)
  end

  Before do
    sandbox
    @custom_layout = Layout.new
  end

  After do
    reset
  end

end