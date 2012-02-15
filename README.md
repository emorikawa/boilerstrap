# Boilerstrap
A ready to go website that integrates Boostrap and HTML5 Boilerplate.
More best practices than you know what to do with.

We support coffeescript, sass, and less.

## Structure:
* Rakefile - Run `rake` to just build and `rake watch` to build and watch
* css
  * bin - All compiled css files end up here
  * lib - Not touched by Rakefile. Include from src.
  * src - All raw css, or less, or sass files.
    * subfolder - All css (ONLY) files are concatenated and put in css/bin as subfolder.css
* js
  * bin - All compiled js files. Each file has a regular and minified version.
  * lib - Not touched by Rakefile. Things like jQuery, etc.
  * src - All raw javascript and/or coffeescript files.
    * subfolder - All files in subfolder are concatenated and put in js/bin as subfolder.js and subfolder.min.js

## Best Practices
* Use the built-in @include directives of less and sass to include files from css/lib.
* Think carefully about what you actually want to concatenate, and what you want to independently load.
* All javascript (except modernizr itself) should be loaded with Modernizr.
