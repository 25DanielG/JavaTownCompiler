cd JavaTownCompiler
rm out/javat
bison -dv javat.y
flex -l javat.l
gcc -o out/javat javat.tab.c lex.yy.c