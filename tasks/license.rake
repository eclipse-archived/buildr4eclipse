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

desc 'Check that source files contain the EPL license'
task 'license' do |task|
  print 'Checking that files contain the EPL license ... '
  
  required = task.prerequisites.select do |fn|
    File.file?(fn) 
  end
  
  missing = required.reject do |fn| 
    comments = File.read(fn).scan(/(\/\*(.*?)\*\/)|^#\s+(.*?)$|^-#\s+(.*?)$|<!--(.*?)-->/m).map do |match| 
      match.compact 
    end.flatten.join("\n")
    comments =~ /Copyright \(c\) 2009 Buildr4Eclipse and others./ && comments =~ /http:\/\/www.eclipse.org\/legal\/epl-v10.html/
  end
  
  fail "#{missing.join(', ')} missing EPL License, please add it before making a release!" unless missing.empty?
  puts 'OK'
end

desc 'Upload the buildr websit to rubyforge'
task 'publish:site' do
  target = "rubyforge.org:/var/www/gforge-projects/buildr4eclipse"
  puts 'Uploading Buildr Web site ...'
  sh 'rsync', '--progress', '--recursive', '--delete', 'website', target
  puts 'Done'
end