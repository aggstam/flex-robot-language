# flex_robot_language

Simple Flex program producing the corresponding C code to validate the syntax of provided RobotLanguage (.rl) code file.
<br>
RobotLanguange LL grammar:
- Robot ::= name “{“ Rules “}”
- Rules ::= “init” R
- R ::= Rule R | ε
- Rule ::= sensor Op T_NUM Action | “halt”
- Action ::= “move” T_NUM | “turn” “left” | “turn” “right

FIRST and FOLLOW sets of grammar:
- FIRST(Robot)={“names”}, FOLLOW(Robot)={EOF}
- FIRST(Rules)={“init”}, FOLLOW(Rules)={“}”}
- FIRST(R)={sensor, “halt”, ε}, FOLLOW(R)={“}”}
- FIRST(Rule)={sensor, “halt”}, FOLLOW(Rule)={sensor, “halt”, “}”}
- FIRST(Action)={“move”, “turn”}, FOLLOW(Action)={sensor, “halt”, “}”}

Compilation and tests execution is streamline via a Makefile.
<br>
Three valid and one invalid test RobotLanguage code files have been provided to play with.

# Usage
```
% make
```
Makefile can be configured to use a different test case set and/or files.

# Execution example
```
❯ make
flex -o flex_robot_language.c flex_robot_language.l
gcc flex_robot_language.c -o flex_robot_language -lfl
./flex_robot_language test_robot_0.rl
 File syntax is correct!
./flex_robot_language test_robot_1.rl
 File syntax is correct!
./flex_robot_language test_robot_2.rl
 File syntax is correct!
./flex_robot_language test_robot_error.rl
 Syntax Error reading . at line 3 of input.
make: [Makefile:15: all] Error 255 (ignored)
```
