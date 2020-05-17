improc : improc.l improc.y
		yacc -d improc.y
		lex improc.l
		gcc lex.yy.c y.tab.c -o improc

run :  improc
			./improc <config.imp

clear :
			rm -f y.tab.c y.tab.h lex.yy.c improc
