# Turing-Machine
`Course Evals`
Both Alex & Lydia filled out the course evals for this class.

`Idea`
-- NEW
The Turing machine (M) for the binary addition problem is designed to check whether a given string is a valid binary addition expression. The input string is expected to be of the form "a+b=c" where a, b, and c are binary numbers. The TM works by reading the input string from left to right and performing the following steps:
1. The TM starts in state 1 and moves to the right until it encounters the first digit of the first binary number (a).
2. The TM moves to the right, reading each digit of the first binary number and storing it in memory.
3. When the TM encounters the + symbol, it writes a * symbol on the tape and moves to the right until it encounters the first digit of the second binary number (b).
4. The TM moves to the right, reading each digit of the second binary number and storing it in memory.
5. When the TM encounters the = symbol, it writes a ** symbol on the tape and moves tothe right until it encounters the first digit of the result (c).
6. The TM moves to the right, reading each digit of the result and storing it in memory.
7. The TM then moves to the left, starting from the rightmost digit of the result, and performs the binary addition operation on the stored numbers, comparing the result to the digits on the tape. If the addition is correct, the TM moves to the right and halts in The accepting state (state 8). If the addition is incorrect, the TM moves to the right and halts in a non-accepting state.
The TM uses its memory to store the binary numbers being added and its tape to keep track of the addition operation. The TM also uses the '* symbol to mark the position of the '+
and = symbols in the input string. This allows the TM to perform the binary addition
operation by moving back and forth on the tape and comparing the result to the digits on the tape.


-- OLD
The Turing machine for the binary addition problem works by reading the input string from left to right, using the '+' and '=' symbols to divide the input into three parts: the left operand, the right operand, and the result. It then moves back to the '+' symbol and checks that the left operand and the right operand are the same, using the binary digits '0' and '1' to compare each position in the operands. If the operands are equal, the Turing machine moves to the accepting state, indicating that the input string is a valid binary addition problem. If the operands are not equal, the Turing machine moves to the rejecting state, indicating that the input string is not a valid binary addition problem.

*Pick a small number of states (3 to 5) and explain what is happening at those states*

`Status`

`Testing`
