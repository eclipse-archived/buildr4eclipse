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

require 'buildr'

#Define the constants used throughout the files
module Buildr4Eclipse
  # The global groupd id for artifacts part of Eclipse instances
  ECLIPSE_GROUP_ID = "eclipse"
end
Dir.glob(File.join(File.dirname(__FILE__), "buildr4eclipse", "*.rb")).each do |f|
  require f
end

