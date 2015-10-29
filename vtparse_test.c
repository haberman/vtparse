/*
 * VTParse - an implementation of Paul Williams' DEC compatible state machine parser
 *
 * Author: Joshua Haberman <joshua@reverberate.org>
 *
 * This code is in the public domain.
 */

#include <stdio.h>
#include <unistd.h>
#include "vtparse.h"

void parser_callback(vtparse_t *parser, vtparse_action_t action, unsigned int ch)
{
    int i;

    printf("Received action %s\n", ACTION_NAMES[action]);
    if(ch != 0) printf("Char: 0x%02x ('%c')\n", ch, ch);
    if(parser->num_intermediate_chars > 0)
    {
        printf("%d Intermediate chars:\n", parser->num_intermediate_chars);
        for(i = 0; i < parser->num_intermediate_chars; i++)
            printf("  0x%02x ('%c')\n", parser->intermediate_chars[i],
                                        parser->intermediate_chars[i]);
    }
    if(parser->num_params > 0)
    {
        printf("%d Parameters:\n", parser->num_params);
        for(i = 0; i < parser->num_params; i++)
            printf("\t%d\n", parser->params[i]);
    }

    printf("\n");
}

int main()
{
    unsigned char buf[1024];
    int bytes;
    vtparse_t parser;

    vtparse_init(&parser, parser_callback);

    do {
        bytes = read(STDIN_FILENO, buf, 1024);
        vtparse(&parser, buf, bytes);
    } while(bytes > 0);

    return 0;
}

