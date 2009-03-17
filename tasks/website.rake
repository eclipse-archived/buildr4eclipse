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

namespace :website do
  begin
    require 'cucumber/rake/task'
    require 'rcov'
    desc "Create the code coverage report"
    Cucumber::Rake::Task.new(:reports) do |t|
      t.cucumber_opts = "-f html -o website/features.html" 
      t.rcov = true
      t.rcov_opts = %w{ --exclude osx\/objc,gems\/,spec\/,buildr\/,features\/ -o website/coverage  }
    end
  rescue LoadError
    puts "Cucumber and rcov required. Please run 'rake setup' first"
  end
  
  desc "Upload to the rubyforge website the contents of website/"
  task :upload do |t|
    # Copied from newgem by Dr Nic
    local_dir = 'website'
    puts "Enter your rubyforge username:"
    username = $stdin.gets.chomp
    host = "rubyforge.org"
    host = host ? "#{host}:" : ""
    remote_dir = "/var/www/gforge-projects/buildr4eclipse"
    sh %{rsync -aCv #{local_dir}/ #{username}@#{host}#{remote_dir}}
  end
  
  desc "Use textile to generate html files out of the txt files in website/"
  task :generate do |t|
    begin
      require "RedCloth"
      require 'syntax/convertors/html'
      require 'erb'
    rescue LoadError
      puts "Make sure RedCloth is installed. You need RedCloth to run this task"
      exit 127
    end
      
    (Dir['website/**/*.txt'] - Dir['website/version*.txt']).each do |txt|
        spec = nil
        eval(File.read(File.join(File.dirname(__FILE__), "../buildr4eclipse.gemspec")))
        download = "http://rubyforge.org/projects/#{spec.name}"
        version = spec.version

        class Fixnum
          def ordinal
            # teens
            return 'th' if (10..19).include?(self % 100)
            # others
            case self % 10
            when 1: return 'st'
            when 2: return 'nd'
            when 3: return 'rd'
            else return 'th'
            end
          end
        end

        class Time
          def pretty
            return "#{mday}#{mday.ordinal} #{strftime('%B')} #{year}"
          end
        end

        def convert_syntax(syntax, source)
          return Syntax::Convertors::HTML.for_syntax(syntax).convert(source).gsub(%r!^<pre>|</pre>$!,'')
        end

        
        src = txt
        template ||= File.join(File.dirname(__FILE__), '/../website/template.html.erb')
        

        template = ERB.new(File.open(template).read)

        title = nil
        body = nil
        File.open(src) do |fsrc|
          title_text = fsrc.readline
          body_text_template = fsrc.read
          body_text = ERB.new(body_text_template).result(binding)
          syntax_items = []
          body_text.gsub!(%r!<(pre|code)[^>]*?syntax=['"]([^'"]+)[^>]*>(.*?)</\1>!m){
            ident = syntax_items.length
            element, syntax, source = $1, $2, $3
            syntax_items << "<#{element} class='syntax'>#{convert_syntax(syntax, source)}</#{element}>"
            "syntax-temp-#{ident}"
          }
          title = RedCloth.new(title_text).to_html.gsub(%r!<.*?>!,'').strip
          body = RedCloth.new(body_text).to_html
          body.gsub!(%r!(?:<pre><code>)?syntax-temp-(\d+)(?:</code></pre>)?!){ syntax_items[$1.to_i] }
        end
        stat = File.stat(src)
        created = stat.ctime
        modified = stat.mtime

        File.open(src.gsub(/txt$/,'html'), "w+") { |f|
          f << template.result(binding)
        } 
      end
  end

end
