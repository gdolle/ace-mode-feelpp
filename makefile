.PHONY : init clean help

help="Usage: make [option]\n\
\nOptions:\n\
\t build - initialize feel++ language \n\
\t make - compile ace with feel++\n\
\t clean - clean all files\n\
\n"

buildmsg="Feel++ syntax files created:\n\
\t - ./build/src/mode-feelpp.js\n\
\t - ./build/src/snippets/feelpp.js\n"

snippet=lib/ace/mode/feelpp.js
rules=lib/ace/mode/feelpp_highlight_rules.js
demo=demo/kitchen-sink/docs/feelpp.feelpp
modelist=lib/ace/ext/modelist.js

exportdir=build/export-gitbook-plugin-ace

all: post-build

pre-build:
	@ln -sf ${PWD}/${snippet} ./ace/${snippet}
	@ln -sf ${PWD}/${rules} ./ace/${rules}
	@ln -sf ${PWD}/${demo} ./ace/${demo}
	@printf "Files initialized!\n"
	@cd ace; npm install
	@printf "Require modules installed!\n"
	# We add Feel++ to tool mode creator
	@cd ace; git checkout ${modelist}
	@sed -i -E "s/(supportedModes\s*=\s*\{)/\1\n\tFeelpp:\t[\"feelpp\"],/g" ace/${modelist}

build: pre-build
	@printf "Compiling ace...\n"
	@cd ace;\
	    $(MAKE) build
	@ln -sf ace/build build 
	@printf ${buildmsg}

post-build: build
	@mkdir -p ${exportdir}
	@mkdir -p ${exportdir}/snippets
	@cp build/src-min/mode-feelpp.js ${exportdir}/
	@cp build/src-min/snippets/feelpp.js ${exportdir}/snippets/

serve:
	@printf "Select Feel++ / Feelpp in the browser to check syntax\n"
	@cd ace; node static.js

clean:
	@rm -rf ./ace/${snippet}
	@rm -rf ./ace/${rules}
	@rm -rf ./ace/${demo}
	@rm -rf build
	@cd ace; $(MAKE) clean
	@cd ace; rm -rf node_modules
	@cd ace; git checkout ${modelist}
	@printf "Cleaned!\n"
help:
	@ printf ${help}
