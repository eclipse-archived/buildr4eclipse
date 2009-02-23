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

Given /a plugin with some dependencies/ do
  manifest = <<-MANIFEST
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: Something.
Bundle-SymbolicName: org.sthg; singleton:=true
Bundle-Version: 6.0.0.000
Bundle-Activator: org.shtg.Activator
Bundle-Vendor: %provider.name
Bundle-Localization: plugin
Export-Package: org.sthg
Bundle-ActivationPolicy: lazy
Require-Bundle: org.eclipse.core.resources,
 org.eclipse.core.runtime,
 org.eclipse.ui
MANIFEST
  Buildr::write 'org.sthg/META-INF/MANIFEST.MF', manifest
end

Then /the compiler should be able to guess them by looking at the manifest/ do
  define 'org.sthg', :base_dir => 'org.sthg' do
    act_as_eclipse_plugin
    @groupId = lambda {|artifactId| return "myEclipseGroup"}
    bundles = autoresolve
    (bundles.include? "myEclipseGroup:org.eclipse.core.resources:").should be_true
  end
end
          
Given /a project identified as a feature, packaging plugins/ do
  pending()
end

Then /Buildr4eclipse should bundle the plugins and generate the feature accordingly/ do
  pending()
end

Given /a project identified as a site, packaging plugins or features/ do
  pending()
end

Then /Buildr4eclipse should bundle the plugins and generate the site accordingly/ do
  pending()
end