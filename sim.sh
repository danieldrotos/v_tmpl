if [ ! -f "$1" ]; then
    exit 1
fi

rm -f a.out
iverilog -s test_mod test_mod.v mods.v ff.v "$1"
rm -f test_mod.vcd
if [ -f a.out ]; then
    vvp a.out
    if [ -f test_mod.vcd ]; then
	gtkwave test_mod.vcd
    fi
fi
