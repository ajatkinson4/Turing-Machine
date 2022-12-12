module TMExamples where

import MonoTM

----------------------------------------------------------------------
-- recognize {a^n b^n c^n | n in Nat }
tripletm =
  TM [1 .. 6] "abc" "abc*! " ' ' '!' trans 1 [6]
  where
    trans = checkRight 1 ' ' 6 ++
            loopRight 1 "*" ++
            goRight 1 'a' '*' 2 ++
            loopRight 2 "a*" ++
            goRight 2 'b' '*' 3 ++
            loopRight 3 "b*" ++
            goRight 3 'c' '*' 4 ++
            loopRight 4 "c*" ++
            checkLeft 4 ' ' 5 ++
            loopLeft 5 "abc*" ++
            checkRight 5 '!' 1 

test = configs tripletm 35 "aabbcc"

----------------------------------------------------------------------
-- recognize language { ww | w in {a,b}* }
ww =
  TM [1..13] "abc" "abc*! " ' ' '!' trans 1 [7]
  where
    checkABLeft p q = 
      checkLeft p 'a' q ++
      checkLeft p 'b' q
    checkABRight p q = 
      checkRight p 'a' q ++
      checkRight p 'b' q
    trans =

      -- [w2] (i) nondeterministically pick an a and erase it
      loopRight 1 "ab" ++
      goLeft 1 'a' '*' 2 ++

      -- [w2] (ii) erase a b
      goLeft 1 'b' '*' 8 ++

      ------------------------------------------
      -- the a loop
      ------------------------------------------
      
      -- [w1] move left through a's and b's only until hitting erasure or left end, then erase matching a
      loopLeft 2 "ab" ++
      checkRight 2 '*' 12 ++
      checkRight 2 '!' 12 ++ 
      goRight 12 'a' '*' 3 ++
      
      -- [w1] skip a's and b's to get to w2
      loopRight 3 "ab" ++

      -- [w2] skip erasures moving right
      checkRight 3 '*' 4 ++
      loopRight 4 "*" ++

      -- [w2] (i) erase first a encountered, then skip all the erasures moving left
      goLeft 4 'a' '*' 5 ++
      loopLeft 5 "*" ++

      -- [w1] (a) skip at least one a or b to move back to the start of the a loop
      checkABLeft 5 2 ++

      -- [w1] (b) instead nondeterministically erase an a, because otherwise you might be moving to the left of the last remaining a
      goRight 5 'a' '*' 3 ++
  
      -- [w2] (ii) if instead of an a, you see b, drop down to the b loop
      goLeft 4 'b' '*' 11 ++

      -- [w2] skip erasures
      loopLeft 11 "*" ++

      -- [w1] (a) skip at least one a or b to move back to start of the b loop
      checkABLeft 11 8 ++

      -- [w1] (b) instead nondeterministically erase a b, since otherwise you might move past the last remaining b
      goRight 11 'b' '*' 9 ++

      ------------------------------------------
      -- the b loop
      ------------------------------------------

      -- [w1] move left through a's and b's to erase a b
      loopLeft 8 "ab" ++
      checkRight 8 '*' 13 ++
      checkRight 8 '!' 13 ++
      goRight 13 'b' '*' 9 ++
      
      -- [w1] skip a's and b's to get to w2
      loopRight 9 "ab" ++

      -- [w2] skip erasures moving right
      checkRight 9 '*' 10 ++
      loopRight 10 "*" ++

      -- [w2] (i) erase first b encountered, then skip all the erasures moving left
      goLeft 10 'b' '*' 11 ++

      -- [w2] (ii) if instead of a b, you see an a, pop up to the a loop
      goLeft 10 'a' '*' 5 ++

      ---------------------------------
      -- check all erased
      ---------------------------------

      -- if we reach a blank (so after w2)
      checkLeft 4 ' ' 6 ++
      checkLeft 10 ' ' 6 ++

      -- skip all erasures, looking for the left endmarker
      loopLeft 6 "*" ++
      checkRight 6 '!' 7

test2 = accepts ww "aa"

----------------------------------------------------------------------
-- recognize binary strings of the form a+b=c where a + b = c
additionTM =
  TM [1..14] "01+=" "01+*= " ' ' ' ' trans 1 [14]
  where
    trans =
      -- move right until the end of the input string
      loopRight 1 "01+=" ++

      -- skip over the '=' symbol
      goRight 1 '=' '*' 2 ++

      -- move left until the '+' symbol is found
      loopLeft 2 "01+=" ++
      checkRight 2 '+' 3 ++

      -- move right until the '=' symbol is found
      loopRight 3 "01+=" ++
      checkRight 3 '=' 4 ++

      -- move left until the '+' symbol is found
      loopLeft 4 "01+=" ++
      checkRight 4 '+' 5 ++

      -- move right until the end of the input string
      loopRight 5 "01+=" ++

      -- check that the numbers on the left and right sides of the '+' symbol are equal
      checkRight 5 '0' 6 ++
      checkRight 5 '1' 7 ++

      -- if the numbers on the left and right sides of the '+' symbol are equal, then move to the accepting state
      goRight 6 '0' '*' 14 ++
      goRight 7 '1' '*' 14 ++

      -- if the numbers on the left and right sides of the '+' symbol are not equal, then move to the rejecting state
      goRight 6 '1' '*' 8 ++
      goRight 7 '0' '*' 8 ++

      -- reject state (move to the left until the beginning of the input string is reached)
      loopLeft 8 "01+="

test3 = configs additionTM 35 "1101+1101=1010"