require 'buildr/pde'

# define some variables, filesets of dependencies
ECLIPSE_HOME = "/Volumes/data/workspaces/swtbot-2/eclipse"
PLUGINS = "#{ECLIPSE_HOME}/plugins"

COMMON_JARS = FileList.new(
        "#{PLUGINS}/org.eclipse.swt.*.jar",
                "#{PLUGINS}/org.eclipse.jface_*.jar",
                "#{PLUGINS}/org.eclipse.core.runtime_*.jar",
                "#{PLUGINS}/org.eclipse.core.commands_*.jar",
                "#{PLUGINS}/org.eclipse.equinox.common_*.jar",
                "#{PLUGINS}/org.junit4_*/*.jar"
)

DEPS = FileList.new(
        "#{PLUGINS}/org.hamcrest_*.jar",
                "#{PLUGINS}/org.apache.log4j_*.jar",
                "#{PLUGINS}/org.apache.commons.collections_*.jar"
)

# Version number for this release
VERSION_NUMBER = `svn info`.grep(/Revision: /).first.rstrip.split(' ')[1] + "-dev"

# Group identifier for your projects
GROUP = "swtbot-2"
COPYRIGHT = ""

# Specify Maven 2.0 remote repositories here, like this:
repositories.remote << "http://www.ibiblio.org/maven2"

desc "The SWTBot-2 project"
define "swtbot-2" do

    project.version = VERSION_NUMBER
    project.group = GROUP
    manifest["Implementation-Vendor"] = COPYRIGHT
    compile.options.source = '1.5'
    compile.options.target = '1.5'

    puts "Building SWTBot version #{VERSION_NUMBER}"

    properties = YAML.load_file('build.properties.yaml')
    properties.merge!(YAML.load_file('build.developer.properties.yaml')) if (File.exists?('build.developer.properties.yaml'))

    desc 'build the sample project needed for tests'
    define 'org.eclipse.swt.examples', :layout=>create_layout('org.eclipse.swt.examples') do

        plugin_id = project.name.split(':').last

        compile.with(COMMON_JARS).using(:warnings=>false, :debug=>true)

        package.include(create_includes(self, plugin_id))
    end

    desc 'the finder project'
    define 'org.eclipse.swtbot.swt.finder', :layout=>create_layout('org.eclipse.swtbot.swt.finder') do

        compile.with([COMMON_JARS, DEPS].flatten).using(:warnings=>false, :debug=>true)

        test.using(:jruby=>true, :fork=>:once, :fail_on_failure=>false)
        test.using(:java_args => ['-XstartOnFirstThread', '-Dorg.eclipse.swt.internal.carbon.smallFonts']) if properties["os"].casecmp("macosx").zero?

        test.with(project("org.eclipse.swt.examples"))
        test.exclude('*DummyTestDoNotExecuteInAnt', '*AllTests')

        test do
            junitreport = task("junit:report")
            junitreport.invoke
        end

        package.include(create_includes(self, plugin_id))

        check package, 'should inclue basic files, in addition to those defined in build.properties' do
            it.should contain('META-INF/MANIFEST.MF')
            it.should contain('about.html')
            it.should contain('LICENSE.EPL')
            get_includes(self).each {|file| it.should contain(file)}
        end
    end
    
    # desc 'the generator project'
    # define 'org.eclipse.swtbot.generator', :layout=>create_layout('org.eclipse.swtbot.generator') do
    # 
    #     compile.with([COMMON_JARS, DEPS, project("org.eclipse.swtbot.swt.finder")].flatten).using(:warnings=>false, :debug=>true)
    # 
    #     test.using(:jruby=>true, :fork=>:once, :fail_on_failure=>false)
    #     test.using(:java_args => ['-XstartOnFirstThread', '-Dorg.eclipse.swt.internal.carbon.smallFonts']) if properties["os"].casecmp("macosx").zero?
    # 
    #     test do
    #         junitreport = task("junit:report")
    #         junitreport.invoke
    #     end
    # 
    #     package.include(create_includes(self, plugin_id))
    # 
    #     check package, 'should inclue basic files, in addition to those defined in build.properties' do
    #         it.should contain('META-INF/MANIFEST.MF')
    #         it.should contain('about.html')
    #         it.should contain('LICENSE.EPL')
    #         get_includes(self).each {|file| it.should contain(file)}
    #     end
    # end

    # javadoc.from projects('net.sf.swtbot.finder')
    # package :javadoc

end