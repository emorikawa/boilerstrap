JS_SRC = "js/src"
JS_BIN = "js/bin"

CSS_SRC = "css/src"
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

desc 'Compiles, and concatenates javascript and coffeescript'
task :js do
  if FileList["#{JS_SRC}/*.js"].any?
    puts "---> Copying over raw javascript files"
    `cp #{JS_SRC}/*.js #{JS_BIN}/`
  end

  Dir["#{JS_SRC}/*/"].each do |d|
    if FileList["#{d}*.js"].any?
      dname = d.strip.split("/")[-1]
      puts "---> Concatenating all javascript files inside of #{dname} to #{dname}.js"
      `cat #{d}*.js > #{JS_BIN}/#{dname}.js`
    end
  end

  if FileList["#{JS_SRC}/*.coffee"].any?
    if installed? "coffee"
      puts "---> Compiling individual coffeescript files"
      `coffee -c -o #{JS_BIN}/ #{JS_SRC}/*.coffee`
    else
      fail "You need coffeescript! Install it by running: `npm install -g coffee-script`"
    end
  end

  Dir["#{JS_SRC}/*/"].each do |d|
    if FileList["#{d}*.coffee"].any?
      if installed? "coffee"
        dname = d.strip.split("/")[-1]
        puts "---> Concatenating all coffeescript files inside of #{dname} then compiling to #{dname}.js"
        `coffee --join #{JS_BIN}/#{dname}.coffee --compile #{d}*.coffee`
      else
        fail "You need coffeescript! Install it by running: `npm install -g coffee-script`"
      end
    end
  end
end

desc 'Minify all javascript files'
task :minify do
  puts "---> Minifying all javascript files"
  FileList["#{JS_BIN}/*.js"].each do |f|
    fname = f.strip.split("/")[-1]

    # Don't minify things that are already minified!
    if fname.split(".")[-2] != "min"
      if installed? "uglifyjs"
        min_name = fname.insert(fname.rindex(".js"), ".min")
        puts "     Minifying #{fname} to #{min_name}"
        `uglifyjs -o #{JS_BIN}/#{min_name} #{f}`
      else
        fail "You need uglifyjs! Install it by running: `npm install -g uglify-js`"
      end
    end
  end
end

desc 'Compiles, concatenates, and minifies css, less, and sass'
task :css do
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
