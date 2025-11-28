GHDL=ghdl
GHDLFLAGS=-fsynopsys --std=08
MODULES=\
      ../clkUnit/clkUnit.o \
      TxUnit.o \
      testTxUnit.o

TIME=40us
PLOT=output

all: test

test: $(MODULES)
	$(GHDL) -r $(GHDLFLAGS) testTxUnit \
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