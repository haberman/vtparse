/*
 * VTParse - an implementation of Paul Williams' DEC compatible state machine parser
 *
 * Author: Joshua Haberman <joshua@reverberate.org>
 *
 * This code is in the public domain.
 */

#include <stdio.h>
#include "vtparse.h"

void parser_callback(vtparse_t *parser, vtparse_action_t action, unsigned char ch)
{
    int i;

    printf("Received action %s, char=0x%02x\n", ACTION_NAMES[action]);
    printf("Intermediate chars: '%s'\n", parser->intermediate_chars);
    printf("%d Parameters:\n", parser->num_params);
    for(i = 0; i < parser->num_params; i++)
        printf("\t%d\n", parser->params[i]);
    printf("\n");
}

int main()
{
    unsigned char buf[1024];
    int bytes;
    vtparse_t parser;

    vtparse_init(&parser, parser_callback);

    while(1) {
        bytes = read(0, buf, 1024);
        vtparse(&parser, buf, bytes);
    }
}

