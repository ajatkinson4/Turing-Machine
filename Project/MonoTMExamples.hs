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

main = do 
  let test = configs tripletm 35 "aabbcc"
  print test

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
addTM = TM [1 .. 10] "10+=" "10+=! " ' ' '!' trans 1 [10] 

  where 
    trans = checkRight 1 ' ' 7 ++
            loopRight 1 "10+=" ++
            goRight 1 '1' '0' 2 ++
            goRight 1 '0' '1' 3 ++
            goRight 1 '+' '0' 4 ++
            goRight 1 '=' '0' 5 ++
            goRight 1 '!' '0' 6 ++
            loopRight 2 "10+=" ++
            goRight 2 '1' '1' 2 ++
            goRight 2 '0' '0' 2 ++
            goRight 2 '+' '1' 4 ++
            goRight 2 '=' '1' 5 ++
            goRight 2 '!' '1' 6 ++
            loopRight 3 "10+=" ++
            goRight 3 '1' '1' 3 ++
            goRight 3 '0' '0' 3 ++
            goRight 3 '+' '0' 4 ++
            goRight 3 '=' '0' 5 ++
            goRight 3 '!' '0' 6 ++
            loopRight 4 "10+=" ++
            goRight 4 '1' '1' 4 ++
            goRight 4 '0' '0' 4 ++
            goRight 4 '+' '0' 4 ++
            goRight 4 '=' '0' 5 ++
            goRight 4 '!' '0' 6 ++
            loopRight 5 "10+=" ++
            goRight 5 '1' '1' 5 ++
            goRight 5 '0' '0' 5 ++
            goRight 5 '+' '0' 4 ++
            goRight 5 '=' '0' 5 ++
            goRight 5 '!' '0' 6 ++
            loopRight 6 "10+=" ++
            goRight 6 '1' '1' 6 ++
            goRight 6 '0' '0' 6 ++
            goRight 6 '+' '0' 4 ++
            goRight 6 '=' '0' 5 ++
            goRight 6 '!' '0' 6 ++
            loopLeft 4 "10+=" ++
            goLeft 4 '1' '0' 2 ++
            goLeft 4 '0' '1' 3 ++
            goLeft 4 '+' '0' 4 ++
            goLeft 4 '=' '0' 5 ++
            goLeft 4 '!' '0' 6 ++
            loopLeft 5 "10+=" ++
            goLeft 5 '1' '0' 2 ++
            goLeft 5 '0' '1' 3 ++
            goLeft 5 '+' '0' 4 ++
            goLeft 5 '=' '0' 5 ++
            goLeft 5 '!' '0' 6 ++
            loopLeft 6 "10+=" ++
            goLeft 6 '1' '0' 2 ++
            goLeft 6 '0' '1' 3 ++
            goLeft 6 '+' '0' 4 ++
            goLeft 6 '=' '0' 5 ++
            goLeft 6 '!' '0' 6 ++
            loopLeft 7 "10+=" ++
            goLeft 7 '1' '0' 2 ++
            goLeft 7 '0' '1' 3 ++
            goLeft 7 '+' '0' 4 ++
            goLeft 7 '=' '0' 5 ++
            goLeft 7 '!' '0' 6 ++
            checkRight 7 ' ' 7 ++
            checkRight 7 '0' 7 ++
            checkRight 7 '1' 7 ++
            checkRight 7 '+' 7 ++
            checkRight 7 '=' 7 ++
            checkRight 7 '!' 7 ++
            checkRight 7 '*' 7 ++
            checkRight 7 '!' 7
