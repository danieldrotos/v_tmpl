if not exist "%1" exit /b 1
if exist a.out del a.out
iverilog -s test_mod test_mod.v mods.v ff.v "%1"
if exist test_mod.vcd del test_mod.vcd
if exist a.out vvp a.out
if exist test_mod.vcd gtkwave test_mod.vcd
