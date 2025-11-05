GHDL=ghdl
GHDLFLAGS=-fsynopsys --std=08
MODULES=\
    ../ER_1OCTET/er_1octet.o \
	MasterOpl.o \
	SlaveOpl.o \
	TestOpl.o

TIME=4us
PLOT=output

all: test

test: $(MODULES)
	$(GHDL) -r $(GHDLFLAGS) TestOpl \
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

cleanAll:
	echo "Cleaning up..."
	$(GHDL) --remove $(GHDLFLAGS)
	rm -f ${PLOT}.vcd