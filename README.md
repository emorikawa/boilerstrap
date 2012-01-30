# Boilerstrap
A ready to go website that integrates Boostrap and HTML5 Boilerplate.
More best practices than you know what to do with.

## CSS Structure - We use LESS
* less: Put all raw less files inside of this folder. Use less includes to link all files together
* styles_compiled.css The output of all less files.

## Javscript Structure
* lib_compile: Put all site-wide libraries (both 3rd party and application-specific) that should be compiled together and minified
* lib_uncompile: Put all site-wide libraries (only 3rd party) that need to be explicitly included on a page-by-page basis by Modernizr
* app_src: Put all application specific javascript that needs to be included on a page-by-page baseis by Modernizr
* lib.min.src: The compiled and minified version of what is inside of lib_compile
