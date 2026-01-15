GHDL=ghdl
GHDLFLAGS=-fsynopsys --std=08
MODULES=\
    clkUnit.o \
	testClkUnit.o \
	diviseurClk.o

TIME=10us
PLOT=output

all: test

test: $(MODULES)
	$(GHDL) -r $(GHDLFLAGS) testClkUnit \
	--stop-time=${TIME} \
	--vcd=${PLOT}.vcd
       
# Binary depends on the object file
%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Object file depends on source
%.o: %.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

clean:
	echo "Cleaning up..."
	$(GHDL) --remove $(GHDLFLAGS)
	rm -f ${PLOT}.vcd