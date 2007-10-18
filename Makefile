
RUBY_GENERATION_FILES = vtparse_gen_c_tables.rb vtparse_tables.rb

all: vtparse_table.c vtparse_table.h test libvtparse.a

clean:
	rm -f vtparse_table.c vtparse_table.h test vtparse.o vtparse_table.o libvtparse.a

vtparse_table.c: $(RUBY_GENERATION_FILES)
	ruby vtparse_gen_c_tables.rb

vtparse_table.h: $(RUBY_GENERATION_FILES)
	ruby vtparse_gen_c_tables.rb

test: vtparse.c vtparse.h vtparse_table.c vtparse_table.h vtparse_test.c
	gcc -o test vtparse_test.c vtparse.c vtparse_table.c

libvtparse.a: vtparse.o vtparse_table.o
	rm -f $@
	ar r $@ $^
	ranlib $@

.c.o:
	gcc -o $@ -c $<  -O3


.PHONY: all clean

