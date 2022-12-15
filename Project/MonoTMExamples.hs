module TMExamples where

import MonoTM
import Data.ByteString (findIndices)

----------------------------------------------------------------------
-- recognize {a^n b^n c^n | n in Nat }
tripletm =
  TM [1 .. 6] "abc" "abc*! " ' ' '!' trans 1 [6]
  where
    trans = checkRight 1 ' ' 6 ++   -- in state 1, if the current cell is a ' ', then transition from state 1 to the final state 6 and move the readhead right without changing the contents of the cell. the string is accepted
            loopRight 1 "*" ++      -- in state 1, if you encounter a *, move the read head right but stay in state 1
            goRight 1 'a' '*' 2 ++  -- in state 1, if you encounter an a, change it to a *, move the read head right, and go to state 2
            loopRight 2 "a*" ++     -- in state 2, if you encounter an a or a *, move the read head right but stay in state 2
            goRight 2 'b' '*' 3 ++  -- in state 2, if you encounter a b, change it to a *, move the read head right, and go to state 3
            loopRight 3 "b*" ++     -- in state 3, if you encounter a b or a *,  move the read head right but stay in state 3
            goRight 3 'c' '*' 4 ++  -- in state 3, if you encounter a c, change it to a *, move the read head right, and go to state 4
            loopRight 4 "c*" ++     -- in state 4, if you encounter a c or a *, move the read head right but stay in state 4
            checkLeft 4 ' ' 5 ++    -- in state 4, if the current cell is a ' ', then transition from state 4 to state 5 and move the readhead left without changing the contents of the cell
            loopLeft 5 "abc*" ++    -- in state 5, if you encounter an a, b, c, or *, move the read head left but stay in state 5
            checkRight 5 '!' 1      -- in state 5, if the current cell is a !, then transition from state 5 to state 1 and move the readhead right without changing the contents of the cell

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
-- recognize { a+b=c | a,b,c in binary }

additionTM = TM [1..14] "01+=" "01+=*! " ' ' '!' trans 1 [14]
    where
      trans = 

----------------------------------------------
-- check if string is in correct form a+b=c
----------------------------------------------

            checkRight 0 ' ' 6  ++
            loopRight 0 "$" ++
            goRight 0 '0' '$' 1 ++
            loopRight 1 "01$" ++
            checkRight 1 '+' 2 ++ 
            goRight 2 '1' '$' 3 ++
            loopRight 3 "01$" ++
            checkRight 3 '=' 4 ++
            goRight 4 '1' '$' 5 ++
            checkLeft 4 '$' 5 ++
            loopLeft 5 "01+=$" ++
            checkRight 5 '!' 0

-- OLD OLD OLD OLD OLD
        -- checkRight 1 '*' 14 ++     -- in state 1, if the current cell is a *, transition from state 1 to the final state 14 and move the read head right without changing the contents of the cell
        -- loopRight 1 "01" ++        -- in state 1, if you encounter a 0 or 1, stay in state 1 and move the read head right without changing the contents of the cells
        -- goRight 1 '+' '+' 2 ++     -- in state 1, if you encounter a +, move the read head right and go to state 2 without changing the contents of the cell
        -- loopRight 2 "01" ++        -- in state 2, if you encounter a 0 or 1, stay in state 2 and move the read head to the right without changing the contents of the cell
        -- goRight 2 '=' '=' 3 ++     -- in state 2, if you encounter an =, move the read head right and go to state 3 without changing the contents of the cell
        -- loopRight 3 "01" ++        -- in state 3, if you encounter a 0 or 1, stay the state 3 and move the read head to the right without changing the contents of the cell
        -- goLeft 3 ' ' '*' 1         -- in state 3, if you encounter a ' ', this means the TM has reached the end of the input string and did not fail so the input string is in the correct form
                                   -- to denote that the input string is in the correct form, add a * to the end of the input string
                                   -- Note: adding a * to the end of the input string also prevents strings like "0", "0+0", and "0+0=" from passing

----------------------------------------------
-- convert 






