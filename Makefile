
RUBY_GENERATION_FILES = vtparse_gen_c_tables.rb vtparse_tables.rb

all: vtparse_table.c vtparse_table.h test

clean:
	rm -f vtparse_table.c vtparse_table.h test

vtparse_table.c: $(RUBY_GENERATION_FILES)
	ruby vtparse_gen_c_tables.rb

vtparse_table.h: $(RUBY_GENERATION_FILES)
	ruby vtparse_gen_c_tables.rb

test: vtparse.c vtparse.h vtparse_table.c vtparse_table.h vtparse_test.c
	gcc -o test vtparse_test.c vtparse.c vtparse_table.c

.PHONY: all clean

