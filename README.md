# Boilerstrap
A blank slate for the modern web. Just add creativity.

## Wait, what? Why?
I wanted bootstrap, but with all of the HTML5 Boilerplate tweaks, Modernizr loading, js compression, plus better  coffeescript support, and control of js concatenation.

I also wanted an asset organizational strcuture that better assessed the reality that nowdays we live with an uncomforatble mix of compiled and static sources files for css and javascript.

Furthermore, it's nice to have support for coffeescript, less, and sass, plus easy extensibility to whatever else you want.

Finally, I just wanted the peace of mind that with a single clone, I'm ready to go with a robust, clean, efficient, cross-browser, optimized, and organized blank slate.

## How to Use:
* `rake watch` will build everything and watch for new changes.
* Always link from `bin`, put your code in `src` (to compile) and `lib` (to leave alone)
* Use folders in `src` to specify what you want to concatenate together

## Basic Structure & Instructions:
* **Rakefile** - Run `rake` to just build and `rake watch` to build and watch
* **css**
    * **bin** - All compiled css files end up here
    * **lib** - Not touched by Rakefile. You should include from src.
    * **src** - All raw css, or less, or sass files. They are compiled and copied one-to-one to the css/bin directory. Use Less or Sass `@include` directives to combine multiple files together. If using raw css, use subfolders to concatenate files.
        * *your_subfolder* - All css (ONLY) files are concatenated and put in css/bin as `subfolder.css`
* **js**
    * **bin** - All compiled js files. Each file has a regular and minified version.
    * **lib** - Not touched by Rakefile. Meant for things like jQuery, or anything else you don't want compiled.
    * **src** - All raw javascript and/or coffeescript files go here. They are compiled and copied one-to-one to the js/bin directory. Use subfolders if you want concatenation.
        * **global** - All files put in here will be concatenated, compiled, and put in js/bin as `global.js` and `global.min.js`
        * *your_subfolder* - All files in 'your_subfolder' are concatenated, compiled, and put in js/bin as `your_subfolder.js` and `your_subfolder.min.js`
  
## Best Practices
* Use the built-in @include directives of less and sass to include files from css/lib.
* Think carefully about what you actually want to concatenate, and what you want to independently load.
* All javascript (except modernizr itself) should be loaded with Modernizr.

## Dependencies
* `gem install watchr` - To enable code watching
* `npm install -g uglify-js` - To minify javascript
* `npm install -g coffee-script` - To compile coffeescript if you use any
* `npm install -g less` - To compile LESS if you use any
* `gem install sass` - To compile SASS if you use any
