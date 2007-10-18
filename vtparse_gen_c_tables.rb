
require 'vtparse_tables'

class String
    def pad(len)
        self << (" " * (len - self.length))
    end
end

File.open("vtparse_table.h", "w") { |f|
    f.puts "typedef enum {"
    $states_in_order.each_with_index { |state, i|
        f.puts "   VTPARSE_STATE_#{state.to_s.upcase} = #{i},"
    }
    f.puts "} vtparse_state_t;"
    f.puts
    f.puts "typedef enum {"
    $actions_in_order.each_with_index { |action, i|
        f.puts "   VTPARSE_ACTION_#{action.to_s.upcase} = #{i+1},"
    }
    f.puts "} vtparse_action_t;"
    f.puts
    f.puts "typedef unsigned char state_change_t;"
    f.puts "extern state_change_t STATE_TABLE[#{$states_in_order.length}][256];"
    f.puts "extern vtparse_action_t ENTRY_ACTIONS[#{$states_in_order.length}];"
    f.puts "extern vtparse_action_t EXIT_ACTIONS[#{$states_in_order.length}];"
    f.puts "extern char *ACTION_NAMES[#{$actions_in_order.length+1}];"
    f.puts "extern char *STATE_NAMES[#{$states_in_order.length}];"
    f.puts
}

puts "Wrote vtparse_table.h"

File.open("vtparse_table.c", "w") { |f|
    f.puts
    f.puts '#include "vtparse_table.h"'
    f.puts
    f.puts "char *ACTION_NAMES[] = {"
    f.puts "   \"<no action>\","
    $actions_in_order.each { |action|
        f.puts "   \"#{action.to_s.upcase}\","
    }
    f.puts "};"
    f.puts
    f.puts "char *STATE_NAMES[] = {"
    $states_in_order.each { |state|
        f.puts "   \"#{state.to_s}\","
    }
    f.puts "};"
    f.puts
    f.puts "state_change_t STATE_TABLE[#{$states_in_order.length}][256] = {"
    $states_in_order.each { |state|
        f.puts "  {  /* VTPARSE_STATE_#{state.to_s.upcase} */"
        $state_tables[state].each_with_index { |state_change, i|
            if not state_change
                f.puts "    0,"
            else
                (action,) = state_change.find_all { |s| s.kind_of?(Symbol) }
                (state,)  = state_change.find_all { |s| s.kind_of?(StateTransition) }
                action_str = action ? "VTPARSE_ACTION_#{action.to_s.upcase}" : "0"
                state_str =  state ? "VTPARSE_STATE_#{state.to_state.to_s}" : "0"
                f.puts "/*#{i.to_s.pad(3)}*/  #{action_str.pad(33)} | (#{state_str.pad(33)} << 4),"
            end
        }
        f.puts "  },"
    }

    f.puts "};"
    f.puts
    f.puts "vtparse_action_t ENTRY_ACTIONS[] = {"
    $states_in_order.each { |state|
        actions = $states[state]
        if actions[:on_entry]
            f.puts "   VTPARSE_ACTION_#{actions[:on_entry].to_s.upcase}, /* #{state} */"
        else
            f.puts "   0  /* none for #{state} */,"
        end
    }
    f.puts "};"
    f.puts
    f.puts "vtparse_action_t EXIT_ACTIONS[] = {"
    $states_in_order.each { |state|
        actions = $states[state]
        if actions[:on_exit]
            f.puts "   VTPARSE_ACTION_#{actions[:on_exit].to_s.upcase}, /* #{state} */"
        else
            f.puts "   0  /* none for #{state} */,"
        end
    }
    f.puts "};"
    f.puts
}

puts "Wrote vtparse_table.c"

