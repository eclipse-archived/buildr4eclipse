require File.join(File.dirname(__FILE__), 'spec_helpers')


describe 'pde compiler' do

  it 'should not override existing target directory' do
    define 'foo' do
      compile.into('classes')
      lambda { compile.using(:pdec) }.should_not change { compile.target }
    end
  end

  it 'should not change existing list of sources' do
    define 'foo' do
      compile.from('sources')
      lambda { compile.using(:pdec) }.should_not change { compile.sources }
    end
  end

#  it 'should include as classpath dependency' do
#    write 'src/dependency/Dependency.scala', 'class Dependency {}'
#    define 'dependency', :version=>'1.0' do
#      compile.from('src/dependency').into('target/dependency')
#      package(:jar)
#    end
#    write 'src/test/DependencyTest.scala', 'class DependencyTest { var d: Dependency = _ }'
#    lambda { define('foo').compile.from('src/test').with(project('dependency')).invoke }.should run_task('foo:compile')
#    file('target/classes/DependencyTest.class').should exist
#  end

  def define_test1_project
    write 'src/main/java/com/example/Test1.java', 'package com.example; public class Test1 { System.out.println("Hello World"); }'
    define 'test1', :version=>'1.0' do
      package(:jar)
    end
  end
  
  it 'should compile a simple .java file into a .class file' do
    define_test1_project
    task('test1:compile').invoke
    file('target/classes/com/example/Test1.class').should exist
  end

  it 'should package .class into a .jar file' do
    define_test1_project
    task('test1:package').invoke
    file('target/test1-1.0.jar').should exist
    Zip::ZipFile.open(project('test1').package(:jar).to_s) do |zip|
      zip.file.exist?('com/example/Test1.class').should be_true
    end
  end

end


describe 'pdec compiler options' do
  def compile_task
    @compile_task ||= define('foo').compile.using(:pdec)
  end

  def pdec_args
    compile_task.instance_eval { @compiler }.send(:pdec_args)
  end

  it 'should set warnings option to false by default' do
    compile_task.options.warnings.should be_false
  end

  it 'should set wranings option to true when running with --verbose option' do
    verbose true
    compile_task.options.warnings.should be_true
  end

  it 'should use -nowarn argument when warnings is false' do
    compile_task.using(:warnings=>false)
    pdec_args.should include('-nowarn') 
  end

  it 'should not use -nowarn argument when warnings is true' do
    compile_task.using(:warnings=>true)
    pdec_args.should_not include('-nowarn') 
  end

  it 'should not use -verbose argument by default' do
    pdec_args.should_not include('-verbose') 
  end

  it 'should use -verbose argument when running with --trace option' do
    trace true
    pdec_args.should include('-verbose') 
  end

  it 'should set debug option to true by default' do
    compile_task.options.debug.should be_true
  end

  it 'should set debug option to false based on Buildr.options' do
    Buildr.options.debug = false
    compile_task.options.debug.should be_false
  end

  it 'should set debug option to false based on debug environment variable' do
    ENV['debug'] = 'no'
    compile_task.options.debug.should be_false
  end

  it 'should set debug option to false based on DEBUG environment variable' do
    ENV['DEBUG'] = 'no'
    compile_task.options.debug.should be_false
  end

  it 'should use -g argument when debug option is true' do
    compile_task.using(:debug=>true)
    pdec_args.should include('-g')
  end

  it 'should not use -g argument when debug option is false' do
    compile_task.using(:debug=>false)
    pdec_args.should_not include('-g')
  end

  it 'should set deprecation option to false by default' do
    compile_task.options.deprecation.should be_false
  end

  it 'should use -deprecation argument when deprecation is true' do
    compile_task.using(:deprecation=>true)
    pdec_args.should include('-deprecation')
  end

  it 'should not use -deprecation argument when deprecation is false' do
    compile_task.using(:deprecation=>false)
    pdec_args.should_not include('-deprecation')
  end

  it 'should set optimise option to false by default' do
    compile_task.options.optimise.should be_false
  end

  it 'should use -optimise argument when deprecation is true' do
    compile_task.using(:optimise=>true)
    pdec_args.should include('-optimise')
  end

  it 'should not use -optimise argument when deprecation is false' do
    compile_task.using(:optimise=>false)
    pdec_args.should_not include('-optimise')
  end

  it 'should not set target option by default' do
    compile_task.options.target.should be_nil
    pdec_args.should_not include('-target')
  end

  it 'should use -target:xxx argument if target option set' do
    compile_task.using(:target=>'1.5')
    pdec_args.should include('-target:jvm-1.5')
  end

  it 'should not set other option by default' do
    compile_task.options.other.should be_nil
  end

  it 'should pass other argument if other option is string' do
    compile_task.using(:other=>'-unchecked')
    pdec_args.should include('-unchecked')
  end

  it 'should pass other argument if other option is array' do
    compile_task.using(:other=>['-unchecked', '-Xprint-types'])
    pdec_args.should include('-unchecked', '-Xprint-types')
  end

  it 'should complain about options it doesn\'t know' do
    write 'source/Test.scala', 'class Test {}'
    compile_task.using(:unknown=>'option')
    lambda { compile_task.from('source').invoke }.should raise_error(ArgumentError, /no such option/i)
  end

  it 'should inherit options from parent' do
    define 'foo' do
      compile.using(:warnings=>true, :debug=>true, :deprecation=>true, :target=>'1.4')
      define 'bar' do
        compile.using(:pdec)
        compile.options.warnings.should be_true
        compile.options.debug.should be_true
        compile.options.deprecation.should be_true
        compile.options.target.should eql('1.4')
      end
    end
  end

  after do
    Buildr.options.debug = nil
    ENV.delete "debug"
    ENV.delete "DEBUG"
  end
end