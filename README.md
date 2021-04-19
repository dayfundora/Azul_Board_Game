# Azul_Board_Game
This document describes the implementation of the Azul board game, in Prolog.

## Structure
For the implementation of this project, structures were created simulating
the named entities of the game, which will now be discussed in more depth:
*Bag*, *Factory*, *Center*, *Cover*, *Wall*, *Pattern Lines*, *Floor* and other structures to facilitate implementation as *Game*, *Player* and *Strategy*. 

## Strategy
The Strategy structure has a strategy selection method, depending on the number that the player has, in case of wanting to add a new strategy, with the same arguments, it is given a number that is not used by other strategies and can be assigned to any player. The idea was to get all the possible and valid plays and depending on the strategy select one of them.
* **1. Easy**
Of the possible valids moves, the first one found is selected. Regardless of the score.
* **2. Random**
Of the possible valids moves, any one is selected. No matter the score.
* **3. Greedy**
From the possible valids moves, the move that have the best score is selected. Regardless of the long-term score.
* **4. Columns**
This strategy is not implemented. Of the possible moves, the one with the most possibility of completing a column is selected, since being connected gives more punctuation, in addition to the final punctuation that can increase if these columns are completed.
