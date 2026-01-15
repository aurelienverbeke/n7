GHDL=ghdl
GHDLFLAGS=-fsynopsys --std=08
MODULES=\
      RxUnit.o \
      compteur16.o\
      testRxUnit.o \
      controleReception.o \
	  clkUnit.o \
	  diviseurClk.o

TIME=80us
PLOT=output

all: test

test: $(MODULES)
	$(GHDL) -r $(GHDLFLAGS) testRxUnit \
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
