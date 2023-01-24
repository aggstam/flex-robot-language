/* -------------------------------------------------------------------------*/
/*                                                                          */
/* This Flex program produces the corresponding C code to validate          */
/* the syntax of provided RobotLanguage (.rl) code file.                    */
/*                                                                          */
/* Author: Aggelos Stamatiou, May 2017                                      */
/*                                                                          */
/* This source code is free software: you can redistribute it and/or modify */
/* it under the terms of the GNU General Public License as published by     */
/* the Free Software Foundation, either version 3 of the License, or        */
/* (at your option) any later version.                                      */
/*                                                                          */
/* This software is distributed in the hope that it will be useful,         */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of           */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            */
/* GNU General Public License for more details.                             */
/*                                                                          */
/* You should have received a copy of the GNU General Public License        */
/* along with this source code. If not, see <http://www.gnu.org/licenses/>. */
/* -------------------------------------------------------------------------*/

%{
#include <stdio.h>
#include <string.h>

#define TK_WAIT 300
#define TK_LEFT_BRACKET 301
#define TK_RIGHT_BRACKET 302
#define TK_INIT 303
#define TK_HALT 304
#define TK_MOVE 305
#define TK_TURN_LEFT 306
#define TK_TURN_RIGHT 307
#define TK_NAME 308
#define TK_SENSOR 309
#define TK_OP 310
#define TK_NUM 311
#define TK_STOP 312

/* Needed for syntax analyser*/
#define LEXEND 0 

int line = 1;
int token = 0;
%}

ws           [ \t]+
Digit        [0-9]
number       {Digit}+
newline      \n|\x0A|\x0D|\x0A
name         [a-z]*
op           \>|\<|\=
sensor       "left-laser"|"right-laser"|"front-sonar"

%%
{ws}         {/* Do nothing */}
"wait"       {return TK_WAIT;}
"{"          {return TK_LEFT_BRACKET;}
"}"          {return TK_RIGHT_BRACKET;}
"init"       {return TK_INIT;}
"halt"       {return TK_HALT;}
"move"       {return TK_MOVE;}
"turn left"  {return TK_TURN_LEFT;}
"turn right" {return TK_TURN_RIGHT;}
{name}       {return TK_NAME;}
{sensor}     {return TK_SENSOR;}
{op}         {return TK_OP;}
{number}     {return TK_NUM;}
.            {return TK_STOP;}
{newline}    { line++; }
%%

void robot(void);
void rules(void);
void R(void);
void rule(void);
void action(void);
void error_syntax(void);
void match(int tk);

void robot(void) {
    if (token == TK_NAME) {
        match(TK_NAME);
        match(TK_LEFT_BRACKET);
        rules();
        match(TK_RIGHT_BRACKET);
    } else {
        error_syntax();
    }
}

void rules(void) {
    if (token == TK_INIT) {
        match(TK_INIT);
        R();
    } else {
        error_syntax();
    }
}

void R(void) {
    if ((token == TK_SENSOR) || (token == TK_HALT)) {
        rule();
        R();
    } else if (token!=TK_RIGHT_BRACKET) {
        error_syntax();
    }
}

void rule(void) {
    if (token == TK_SENSOR) {
        match(TK_SENSOR);
        match(TK_OP);
        match(TK_NUM);
        action();
    } else if (token == TK_HALT) {
        match(TK_HALT);
    } else {
        error_syntax();
    }
}

void action(void) {
    if (token == TK_MOVE) {
        match(TK_MOVE);
        match(TK_NUM);
    } else if (token == TK_TURN_LEFT) {
        match(TK_TURN_LEFT);
    } else if (token == TK_TURN_RIGHT) {
        match(TK_TURN_RIGHT);
    } else {
        error_syntax();
    }
}

/* Function for error reporting*/
void error_syntax(void) {
    printf(" Syntax Error reading %s at line %d of input.\n",yytext, line);
    exit(-1);
}

/* Function that matches the lookahead symbol (character) and reads the next. */
void match(int tk) {
    if (token == tk) {
        token = yylex();
    } else  {
        error_syntax();
    }
}

int main(int argc, char** argv) {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 ) {
        yyin = fopen( argv[0], "r" );
    } else {
        yyin = stdin;
    }

    token = yylex(); 
    robot();
    if (token == LEXEND) {
        printf(" File syntax is correct!\n");
    } else {
        error_syntax();
    }

   return 0;
}
