# Turing-Machine
`Course Evals`
Both Alex & Lydia filled out the course evals for this class.

`Idea`
The TM for binary addition takes an input string, x, and checks whether x is of the form a+b=c and whether a plus b indeed equals c. a, b, & c are binary numbers. We chose to have our TM break down the addition problem into multiple tasks according to the following:
1. a. Check if the string is in the correct form a+b=c. If the string is not in the correct form, the TM halts in a non-final state,
   indicating the string is not in the language. 
   b. While checking if the string is in the correct form, our TM simultaneously checks that a, b, & c are all numbers in binary. If any of the numbers are not in binary, the TM halts in a non-final state, indicating that the string is not the language. 
   If the string is in the correct form and all of the numbers are in binary, the TM moves onto task 2.
2. Check if a & b equal c. 


*Pick a small number of states (3 to 5) and explain what is happening at those states*

`Status`
Currently, our TM has the capability to check if the input string x is in the correct form a+b=c and whether a, b, and c are numbers in binary or not.

We are still working on a solution to check that a plus b indeed equals c.

`Testing`
The TM is working properly thus far, granted we only have task 1 completed.

Task 1 Testing:
    ghci> accepts additionTM  "0+0=0"
    True

    ghci> accepts additionTM "0"
    False

    ghci> accepts additionTM "a"
    False

    ghci> accepts additionTM "0+0"
    False

    ghci> accepts additionTM "1+1=a"
    False

    ghci> accepts additionTM  "000001+100000=100001"
    True
    

