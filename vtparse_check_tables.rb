
require 'vtparse_tables'

#
# check that for every state, there is a transition defined
# for every character between 0 and A0.
#

table = {}

$state_tables.each { |state, table|
    table.each_with_index { |val, i|
        if not val
            raise "No transition defined from state #{state}, char 0x#{i.to_s(16)}!"
        end
    }
}

puts "Tables had all necessary transitions defined."

