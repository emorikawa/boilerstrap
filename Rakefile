JS_SRC = "js/src"
JS_LIB = "js/lib"
JS_BIN = "js/bin"

CSS_SRC = "css/src"
CSS_LIB = "css/lib"
CSS_BIN = "css/bin"

# Compiles scripts
def installed?(program)
  cmd = "which #{program}"
  File.executable?(`#{cmd}`.strip)
end

desc 'Runs all javascript and css related jobs'
task :default do
  Rake::Task['js'].invoke
  Rake::Task['minify'].invoke
  Rake::Task['css'].invoke
  puts "==== DONE ===="
end

task :watch do
  Rake::Task['js'].invoke
  Rake::Task['minify'].invoke
  Rake::Task['css'].invoke
  begin
    require 'watchr'
    script = Watchr::Script.new
    script.watch('(js|css)/(src|lib)/.*') { system 'rake' }
    contrl = Watchr::Controller.new(script, Watchr.handler.new)
    contrl.run
  rescue LoadError
    fail "You need watchr! Install it by running `gem install watchr`"
  end
end


def compileSubFolder()
  Dir["#{JS_SRC}/*/"].each do |d|
    dname = d.strip.split("/")[-1]
    # We need to clear the file before building it again
    File.delete "#{JS_BIN}/#{dname}.js" if File.exists? "#{JS_BIN}/#{dname}.js"
    line_num = 0
    num_files = FileList["#{d}*.coffee"].size + FileList["#{d}*.js"].size

    # Concatenate in the order of the 'ORDERING' file
    if File.exist? "#{d}ORDERING"
      js_files = []
      coffee_files = []
      file = File.new("#{d}ORDERING", 'r')
      file.each_line("\n") do |l|
        l = l.strip
        if l == "" then next end

        extension = l.split('.')[-1].downcase
        if extension == "coffee"
          coffee_files << l
        elsif extension == "js"
          js_files << l
        else
          $stderr.puts "XXX> WARNING! #{l} must have a valid *.coffee or *.js ending"
        end
        line_num += 1
      end

      if num_files != line_num
        $stderr.puts "XXX> WARNING! The number of files in #{dname} does not match the number in 'ORDERING'. You may be forgetting to concatenate some."
      end

      if not js_files.empty?
        puts "---> Using ORDERING file to concatenate JAVASCRIPT files inside of #{dname} to #{dname}.js"
      end

      for js_file in js_files
        puts "     #{dname}.js <--- #{dname}/#{js_file}"
        if File.exists? "#{JS_BIN}/#{dname}.js"
          `cat #{d}#{js_file} >> #{JS_BIN}/#{dname}.js`
        else
          `cat #{d}#{js_file} > #{JS_BIN}/#{dname}.js`
        end
      end

      if not coffee_files.empty?
        puts "---> Using ORDERING file to concatenate COFFEESCRIPT files inside of #{dname} to #{dname}.js"
      end

      `rm -rf #{d}tmp/` if File.directory? "#{d}tmp/"
      for coffee_file in coffee_files
        puts "     #{dname}.js <--- #{dname}/#{coffee_file}"
        `coffee --compile --output #{d}tmp/ #{d}#{coffee_file}`
      end
      for compiled_coffee in FileList["#{d}tmp/*"]
        if File.exists? "#{JS_BIN}/#{dname}.js"
          `cat #{compiled_coffee} >> #{JS_BIN}/#{dname}.js`
        else
          `cat #{compiled_coffee} > #{JS_BIN}/#{dname}.js`
        end
      end
      `rm -rf #{d}tmp/`

    # Otherwise simply concatenate in the order of directory listing
    else
      js_files = FileList["#{d}*.js"]
      if js_files.any?
        puts "---> Concatenating all javascript files inside of #{dname} to #{dname}.js"
        for js_file in js_files
          puts "     #{dname}.js <--- #{dname}/#{js_file.split("/")[-1]}"
        end
        `cat #{d}*.js > #{JS_BIN}/#{dname}.js`
      end
      coffee_files = FileList["#{d}*.coffee"]
      if coffee_files.any?
        if installed? "coffee"
          puts "---> Concatenating all coffeescript files inside of #{dname} then compiling to #{dname}.js"
          for coffee_file in coffee_files
            puts "     #{dname}.js <--- #{dname}/#{coffee_file.split("/")[-1]}"
          end
          `coffee --join #{JS_BIN}/#{dname}.js --compile #{d}*.coffee`
        else
          fail "You need coffeescript! Install it by running: `npm install -g coffee-script`"
        end
      end
    end
  end
end

desc 'Compiles, and concatenates javascript and coffeescript'
task :js do
  puts "\n=== COMPILE JAVASCRIPT ==="
  ### COMPILE INDIVIDUAL FILES
  js_files = FileList["#{JS_SRC}/*.js"]
  if js_files.any?
    puts "---> Copying over raw javascript files"
    `cp #{JS_SRC}/*.js #{JS_BIN}/`
    for js_file in js_files
      js_file = js_file.split("/")[-1]
      puts "     #{js_file}.js <--- #{js_file}.js"
    end
  end

  coffee_files = FileList["#{JS_SRC}/*.coffee"]
  if coffee_files.any?
    if installed? "coffee"
      puts "---> Compiling individual coffeescript files"
      `coffee -c -o #{JS_BIN}/ #{JS_SRC}/*.coffee`
      for coffee_file in coffee_files
        coffee_file = coffee_file.split("/")[-1]
        puts "     #{coffee_file}.js <--- #{coffee_file}.coffee"
      end
    else
      fail "You need coffeescript! Install it by running: `npm install -g coffee-script`"
    end
  end

  ### COMPILE SUB FOLDERS
  compileSubFolder()

end

desc 'Minify all javascript files'
task :minify do
  puts "\n=== MINIFY JAVASCRIPT ==="
  puts "---> Minifying all javascript files"
  FileList["#{JS_BIN}/*.js"].each do |f|
    fname = f.strip.split("/")[-1]
    # Don't minify things that are already minified!
    if fname.split(".")[-2] != "min"
      if installed? "uglifyjs"
        min_name = fname.insert(fname.rindex(".js"), ".min")
        puts "     Minifying #{f.strip.split("/")[-1]} to #{min_name}"
        `uglifyjs -o #{JS_BIN}/#{min_name} #{f}`
      else
        fail "You need uglifyjs! Install it by running: `npm install -g uglify-js`"
      end
    end
  end
end

desc 'Compiles, concatenates, and minifies css, less, and sass'
task :css do
  puts "\n=== COMPILE CSS ==="
  if FileList["#{CSS_SRC}/*.css"].any?
    puts "---> Copying over raw css files"
    `cp #{CSS_SRC}/*.css #{CSS_BIN}/`
  end

  Dir["#{CSS_SRC}/*/"].each do |d|
    if FileList["#{d}*.css"].any?
      dname = d.strip.split("/")[-1]
      puts "---> Concatenating all css files inside of #{dname} to #{dname}.css"
      `cat #{d}*.css > #{CSS_BIN}/#{dname}.css`
    end
    if FileList["#{d}*.less"].any?
      fail "You should not concatenate less files. Use the @import directive instead and put extra less files in the 'lib' directory"
    end
    if FileList["#{d}*.scss"].any?
      fail "You should not concatenate scss files. Use the @import directive instead and put extra scss files in the 'lib' directory"
    end
  end

  if FileList["#{CSS_SRC}/*.less"].any?
    FileList["#{CSS_SRC}/*.less"].each do |f|
      fname = f.strip.split("/")[-1]
      if installed? "lessc"
        css_name = fname.sub(/\.less/, ".css")
        puts "---> Compiling #{fname} to #{css_name}"
        `lessc #{f} > #{CSS_BIN}/#{css_name}`
      else
        fail "You need less! Install it by running: `npm install -g less`"
      end
    end
  end

  if FileList["#{CSS_SRC}/*.scss"].any?
    FileList["#{CSS_SRC}/*.scss"].each do |f|
      fname = f.strip.split("/")[-1]
      if installed? "sass"
        css_name = fname.sub(/\.scss/, ".css")
        puts "---> Compiling #{fname} to #{css_name}"
        `sass #{f} > #{CSS_BIN}/#{css_name}`
      else
        fail "You need sass! Install it by running: `gem install sass`"
      end
    end
  end
end
