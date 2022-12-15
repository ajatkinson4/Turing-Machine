# Turing-Machine
`Course Evals`
Both Alex & Lydia filled out the course evals.

`Idea`
The TM for binary addition takes an input string, x, and checks whether x is of the form a+b=c and whether a plus b indeed equals c. a, b, & c are binary numbers. Our TM simultaneously checks that x is in the correct form, that a, b, & c are numbers in binary, & that a plus b indeed equals c. 

The turing machine starts by checking the least significant bit of binary number a. If it is a 0, the TM will go down one path and if it is a 1, the TM will go down another path. The TM has to takes different paths based on whether a starts with a 0 or a 1 because whether there is a 0 or a 1 determines what will end up c. Basically, our TM goes down 1 path for 0_+1_, another path for 1_+0_, & a 3rd path for 0_+0_. Note: our TM is not equipped to handle 1+_1_ because it doesn't know how to handle the carry. 

After the TM checks the least significant bit of a it changes the contents of a to a * symbol to mark that the TM checked that bit. The TM then skips over the remaining bits in a and the plus sign following a and checks the least significant bit of b, again marking this bit with a * to denote that the TM has checked this bit. The TM then skips over the remaining bits b and the equals sign following b and checks the least significant bit of c. If the least significant bit of a plus the least significant bit of b equals the least significant bit in c, the TM changes the least significant bit of c to a star and loops back to the beginning of the input string. If the bits of a and b do not equal the bit in c when added together, the TM will end in a non-final state, meaning the string is not in the language of the TM. 

The TM will repeat this same process for each succeeding bit in a, b, & c. If the TM stumbles upon a bit that is not a 0 or 1, finds that the string is not in the correct form, or finds that the bits in a and b do not equal c, the TM will end in a non-final state. If the TM makes it through the entire string and finds that the entire string is made up of the * symbol, it will end in a final state. 

`Status`
Our TM is fully functioning except for in the case when there is a carry (from _1_+_1_=_0_). 

`Testing`
The following examples demonstrate that our TM correctly checks whether the input string is in the correct form, a+b=c:

The input string is "00+00=". This string is not accepted.
    ghci> accepts binaryAdditionTM "00+00="
    False

The input string is "000". This string is not accepted.
    ghci> accepts binaryAdditionTM "000"
    False       

The input string is "0+0=0". This string is accepted.
    ghci> accepts binaryAdditionTM "0+0=0"
    True    

The following examples demonstrate that our TM correctly checks that a, b, & c are binary numbers:

The input string is "0+0=a". This string is not accepted.
    ghci> accepts binaryAdditionTM "0+0=a"
    False

The input string is "002+000=001". This string is not accepted. 
    ghci> accepts binaryAdditionTM "002+000=001"
    False   

The input string is "01+10=11". This string is accepted.
    ghci> accepts binaryAdditionTM "01+10=11"
    True

The following examples demonstrate that our TM correctly checks that a plus b indeed equals c:

The input string is "000+111=111". This string is accepted.
ghci> configs binaryAdditionTM 70 "000+111=111"
    [[1: "!0" "00+111=111"]]
    [[2: "!*0" "0+111=111"]]
    [[2: "!*00" "+111=111"]]
    [[2: "!*00+" "111=111"]]
    [[3: "!*00+1" "11=111"]]
    [[4: "!*00+*1" "1=111"]]
    [[4: "!*00+*11" "=111"]]
    [[4: "!*00+*11=" "111"]]
    [[5: "!*00+*11=1" "11"]]
    [[6: "!*00+*11=*1" "1"]]
    [[6: "!*00+*11=*" "11"]]
    [[6: "!*00+*11=" "*11"]]
    [[6: "!*00+*11" "=*11"]]
    [[6: "!*00+*1" "1=*11"]]
    [[6: "!*00+*" "11=*11"]]
    [[6: "!*00+" "*11=*11"]]
    [[6: "!*00" "+*11=*11"]]
    [[6: "!*0" "0+*11=*11"]]
    [[6: "!*" "00+*11=*11"]]
    [[6: "!" "*00+*11=*11"]]
    [[1: "!*" "00+*11=*11"]]
    [[1: "!*0" "0+*11=*11"]]
    [[2: "!**0" "+*11=*11"]]
    [[2: "!**0+" "*11=*11"]]
    [[3: "!**0+*" "11=*11"]]
    [[3: "!**0+*1" "1=*11"]]
    [[4: "!**0+**1" "=*11"]]
    [[4: "!**0+**1=" "*11"]]
    [[5: "!**0+**1=*" "11"]]
    [[5: "!**0+**1=*1" "1"]]
    [[6: "!**0+**1=**1" ""]]
    [[6: "!**0+**1=**" "1"]]
    [[6: "!**0+**1=*" "*1"]]
    [[6: "!**0+**1=" "**1"]]
    [[6: "!**0+**1" "=**1"]]
    [[6: "!**0+**" "1=**1"]]
    [[6: "!**0+*" "*1=**1"]]
    [[6: "!**0+" "**1=**1"]]
    [[6: "!**0" "+**1=**1"]]
    [[6: "!**" "0+**1=**1"]]
    [[6: "!*" "*0+**1=**1"]]
    [[6: "!" "**0+**1=**1"]]
    [[1: "!*" "*0+**1=**1"]]
    [[1: "!**" "0+**1=**1"]]
    [[1: "!**0" "+**1=**1"]]
    [[2: "!***+" "**1=**1"]]
    [[3: "!***+*" "*1=**1"]]
    [[3: "!***+**" "1=**1"]]
    [[3: "!***+**1" "=**1"]]
    [[4: "!***+***=" "**1"]]
    [[5: "!***+***=*" "*1"]]
    [[5: "!***+***=**" "1"]]
    [[5: "!***+***=**1" ""]]
    [[6: "!***+***=*** " ""]]
    [[1: "!***+***=***" "*"]]
    [[1: "!***+***=****" ""]]
    [[1: "!***+***=**** " ""]]
    [[7: "!***+***=****  " ""],[14: "!***+***=****  " ""]]
    [[14: "!***+***=****  " ""]]

    ghci> accepts binaryAdditionTM "000+111=111"
    True

The input string is "110+001=011". This string is not accepted.

    ghci> configs binaryAdditionTM 70 "110+001=011"
    [[1: "!1" "10+001=011"]]
    [[9: "!*1" "0+001=011"]]
    [[9: "!*10" "+001=011"]]
    [[9: "!*10+" "001=011"]]
    [[10: "!*10+0" "01=011"]]
    [[11: "!*10+*0" "1=011"]]
    [[11: "!*10+*01" "=011"]]
    [[11: "!*10+*01=" "011"]]
    [[12: "!*10+*01=0" "11"]]

    ghci> accepts binaryAdditionTM "110+001=011"
    False