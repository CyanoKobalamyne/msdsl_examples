BUILDDIR = gen
MODEL_SCRIPTS = $(wildcard generate_*_model.py)
MODEL_SOURCES = $(patsubst generate_%.py,%.sv,$(MODEL_SCRIPTS))
TOP_SOURCES = $(filter-out $(MODEL_SOURCES),$(wildcard *.sv))
TOP_BTORS = $(patsubst %.sv,$(BUILDDIR)/%.btor,$(TOP_SOURCES))
LIB_SOURCES = $(wildcard lib/*.sv)

all: $(TOP_BTORS)

$(BUILDDIR)/%.btor: $(BUILDDIR)/synthesize_%.ys %.sv $(MODEL_SOURCES) $(LIB_SOURCES)
	mkdir -p $(@D)
	yosys $<

%_model.sv: generate_%_model.py
	python $< > $@

$(BUILDDIR)/synthesize_%.ys: make_synthesis_script.sh
	mkdir -p $(@D)
	sh $< $*.sv $* $(BUILDDIR)/$*.btor > $@

clean:
	rm -rf $(BUILDDIR)

cleanall: clean
	rm -rf *_model.sv

.PHONY: all clean

.NOTINTERMEDIATE:
