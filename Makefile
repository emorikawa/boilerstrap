VERSION=1.0.0
DATE=$(shell date)
LESS = ./css/less/styles.less
CSS = ./css/styles_compiled.css
MIN_CSS = ./css/styles_compiled.min.css
LESS_COMPRESSOR ?= `which lessc`
UGLIFY_JS ?= `which uglifyjs`
WATCHR ?= `which watchr`

build:
	make less;
	make js/min;

less:
	@@if test ! -z ${LESS_COMPRESSOR}; then \
		sed -e 's/@VERSION/'"v${VERSION}"'/' -e 's/@DATE/'"${DATE}"'/' <${LESS} >${LESS}.tmp; \
		lessc ${LESS}.tmp > ${CSS}; \
		lessc ${LESS}.tmp > ${MIN_CSS} --compress; \
		rm -f ${LESS}.tmp; \
		echo "CSS successfully built! - `date`"; \
	else \
		echo "You must have the LESS compiler installed in order to build Boilerstrap."; \
		echo "You can install it by running: npm install less -g"; \
	fi

js/min:
	@@if test ! -z ${UGLIFY_JS}; then \
		cat js/lib_compile/*.js > js/lib_cat.tmp; \
		uglifyjs -o js/lib.min.js js/lib_cat.tmp; \
		rm -f js/lib_cat.tmp; \
		echo "Javascript libraries successfully built! - `date`"; \
	else \
		echo "You must have the UGLIFYJS minifier installed in order to minify Bootstrap's js."; \
		echo "You can install it by running: npm install uglify-js -g"; \
	fi

watch:
	@@if test ! -z ${WATCHR}; then \
		echo "Watching less and javascript files..."; \
		watchr -e "watch('(css|js)/(lib_compile|less).*\.(less|js)') { system 'make' }"; \
	else \
		echo "You must have the watchr installed in order to watch Bootstrap less files."; \
		echo "You can install it by running: gem install watchr"; \
	fi

.PHONY: build watch
