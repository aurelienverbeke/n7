GHDL=ghdl
#GHDL=/mnt/n7fs/ens/tp_guivarch/opt2023/ghdl-2.0.0/bin/ghdl
GHDLFLAGS=--std=08
MODULES=\
    demi_additionneur.o \
	porte_ou.o \
	additionneur.o \
	additionneur_4bits.o \
    test_additionneur.o \
	test_additionneur_4bits.o \
	test_additionneur \
	test_additionneur_4bits

TIME=2us
PLOT=output

all: test

test: $(MODULES)
	$(GHDL) -r $(GHDLFLAGS) test_additionneur test_additionneur_4bits \
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
