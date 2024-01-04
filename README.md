Ever wanted to build your own compiler? My group did! This is our attempt. Try our Beep Compiler -- A compiler that reads basic C++ syntax :)

## Installation

clone this repo

```sh
git clone https://github.com/alexchsieh/Beep-Compiler.git
```

## Tools

install flex (2.5.37)

```sh
sudo apt install flex-old
```

install bison (3.0.4)

```sh
sudo apt install bison
```

## Usage example

might need to give the file permissions
```sh
chmod 777 ./mil_run
```

having our parser print the .min version of the code and converting it to .mil
```sh
cat ../programs/add.beep | parser >> add.mil
```

using mil interpreter to run the .mil file
```sh
mil_run add.mil
```

sample output
```
150
```

### Disclaimer
The code works with flex-old and is incompatible with flex, due to the updates with how flex registers blank space characters.

# Beep Compiler Project: Phase 4
## Language Name: BEEP-L
## Compiler Name: BEEP-LC
## Extension: .beep

| Language Feature | Code Example |
| --- | --- |
| Integer scalar variables | int x, int y, int integer |
| 1-D array | int array_name [4] |
| Assignment statements | x = 5 |
| Arithmetic operators | 1+1, 2-1, 1*5, 6/1, 6%2 |
| Comparison operators | x < y, y == z, 8 > x, 1 <= 2, 3 >= 2, x != y |
| While Loops | loop x > 5 |
| "break" and "continue" loop control statements | while (condition) {<br>&ensp; if (condition to break) {<br>&ensp; break; <br>&ensp;}<br>&ensp; if (condition to continue) {<br>&ensp;&ensp; continue; <br>&ensp;}<br>} | 
| If-then-else statements | if (condition 1) {<br>&ensp; run code if condition 1 is true.<br>}<br> else if (condition 2){<br>&ensp;&ensp; run code if condition 1 is false and condition 2 is true.<br>}<br> else {<br>&ensp;&ensp; run code if condition 1 is false and condition 2 is false.<br>}<br> |
| Read and Write statements | read(), write|
| Comments | ``// this line is a comment! `` |
| Functions | void function_name_() , int function_name(parameters), int addition (int a, int b) |
| Parameters | (3, 4, 5) |


| Language Feature | Token Name |
| --- | --- |
| int | INTEGER |
| + | ADDITION |
| - | SUBTRACTION |
| * | MULTIPLICATION |
| % | MOD |
| / | DIVISION |  
| , | COMMA |
| ; | END_STATEMENT |
| \[ | OPEN_BRACKET |
| \] | CLOSE_BRACKET |
| ( | OPEN_PARAMETER |
| ) | CLOSE_PARAMETER |
| { | OPEN_SCOPE |
| } | CLOSE_SCOPE |
| < | LESS_THAN |
| <= | LESS_THAN_OR_EQUAL_TO |
| > | GREATER_THAN |
| >= | GREATER_THAN_OR_EQUAL_TO |
| = | ASSIGN |
| == | EQUALS_TO |
| != | NOT_EQUALS_TO |
| while | WHILE |
| break | BREAK |
| continue | CONTINUE |
| if | IF |
| else | ELSE |
| cin | READ |
| cout | WRITE |
| // | COMMENT |
| return | RETURN |
| endl | ENDL | 
