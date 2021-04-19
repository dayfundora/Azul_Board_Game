# Azul_Board_Game
This document describes the implementation of the Azul board game, in Prolog.

## Structure
For the implementation of this project, structures were created simulating
the named entities of the game, which will now be discussed in more depth:
*Bag*, *Factory*, *Center*, *Cover*, *Wall*, *Pattern Lines*, *Floor* and other structures to facilitate implementation as *Game*, *Player* and *Strategy*. 

### 1. Bag
The Bag is where the tiles are stored since the start of the game has
a structure:
	    `[[blue,CountBlue],
	  [yellow,CountYellow],
	  [white,CountWhite],
	  [black,CountBlack],
	  [red,CountRed]]`
The order of colors and quantity of elements is maintained, they only change
the quantities of the colors, and these always remain positive.
The Bag only interacts with the Cover and the Factories, and you only have the option of receive and give tiles (either one, several, of a specific color or random).
Main methods to interact with other structures:

##### initializeBag
```
initializeBag/1
initializeBag (Bag)
```
Generate a bag for the start of the game with 20 tiles of each color.

##### takeTileRandomBag
```
takeTileRandomBag / 3
takeTileRandomBag (Bag, ColorR, BagR)
```
Select a random tile from the bag.

##### takeNTilesBagForFactory
```
takeNTilesBagForFactory / 5
takeNTilesBagForFactory (Bag, Factory, Quantity, FactoryR, BagR)
```
Select a quantity *Quantity* of random tiles from the Bag to the factory.

##### putNColorsBag
```
putNColorsBag / 3
putNColorsBag (Bag, ListColorQant, BagR)
```
Puts a list of colors (with their respective quantities) on the Bag.

### 2. Cover
The Cover is where the tiles are stored after the players
discard, before going to the Bag and has a similar structure to the Bag.
	    `[[blue,CountBlue],
	  [yellow,CountYellow],
	  [white,CountWhite],
	  [black,CountBlack],
	  [red,CountRed]]`
The Cover interacts with the Bag and the Players, it also only has the option of receiving and giving tiles (the tiles are all given to the Bag at once), wait for the Bag to be empty, and pass all the tiles.

##### initializeCover
```
initializeCover/1
initializeCover (Cover)
```
Generate an empty Cover, with 0 tiles of each color.

##### emptyCoverInBag
```
emptyCoverInBage / 4
emptyCoverInBage (Bag, Cover, BagR, CoverR)
```
Put all the tiles from the lid in the bag.

##### putColorsCover
```
putColorsCover / 3
putColorsCover (Bag, LisColorCount, BagR)
```
Puts a list of colors (with their respective quantities) on the bag

##### putFloorCover
```
putFloorCover / 3
putFloorCover (Cover, ListColor, CoverR)
```
It puts a list of colors (without quantities), which is the way in which the floor gives the tiles.

### 3. Factory
Factories are structures that store 4 tiles, the amount of these is `1 + 2*Players`, which is defined at the start of the game. Players can take tiles of the same color in a Factory and those they discard go to the Center.The structure of the Factories is the same as in the Cover and the Bag:
	    `[[blue,CountBlue],
	  [yellow,CountYellow],
	  [white,CountWhite],
	  [black,CountBlack],
	  [red,CountRed]]`
The Factories interacts with the Bag, the Center and the Players, and only have the option of receiving and giving tiles (the tiles are all of one color).

##### initializeFactory
```
initializeFactory/1
initializeFactory (Factory)
```
Generate the arranged amount of factories four random tiles in each one.

##### fillFactory
```
fillFactory / 4
fillFactory (Factory, Bag, FactoryR, BagR)
```
Fill each factory with tiles.

##### quantityTilesFactoryColor
```
quantityTilesFactoryColor / 3
quantityTilesFactoryColor (Factory, Color, Quantity)
```
Tells the number of tiles of one color in a factory.

##### selectTilesFactoryColor
```
selectTilesFactoryColor / 6
selectTilesFactoryColor (Factory, Center, Color, FactoryR, CenterR, QuantColor)
```
He selects tiles of one color from a factory and takes the rest to the center.

### 4. Center
The Center is a structures that have tiles like the Factory but not limited to 4 tiles. Players can pick up tiles of the same color in the Center just like in Factories and the tiles arrive by being discarded from the Factory. The structure of the Center is the same as in the Factories.

	    `[[blue,CountBlue],
	  [yellow,CountYellow],
	  [white,CountWhite],
	  [black,CountBlack],
	  [red,CountRed]]`

The Center interacts with the Factories and the Players, it also only has the option of receiving and giving tiles (the tiles are all of one color).

##### initializeCenter
```
initializeCenter/1
initializeCenter (Center)
```
Generate a empty Center, without tiles.

##### putCenterColorList
```
putCenterColorList / 3
putCenterColorList (Center, ColorList, CenterR)
```
Puts all the tiles in the color list in the center.

##### RemoveColorCenter
```
removeColorCenter / 3
removeColorCenter (Center, Color, CenterR, QuantColor)
```
Remove all tiles of one color from the center.
### 5. Player
The Player structure is where the information about Wall, Pattern Lines, Floor, Score and Strategy of each Player is and has the following structure:
```
[Wall, Pattern_Lines, Floor, Score, Strategy]
```
It always maintains the order of colors and quantity of elements, it is a player with his board and the number of strategy to use

### 5.1 Wall
The Wall is a predefined structure that can be used to put colored tiles in a specific place. At the end of each round the players can, if the conditions are met, put tiles on the wall. The structure of the wall is:
    [[[blue, Bool], [yellow, Bool], [red, Bool], [black, Bool], [white, Bool]],
    [[white, Bool], [blue, Bool], [yellow, Bool], [red, Bool], [black, Bool]],
    [[black, Bool], [white, Bool], [blue, Bool], [yellow, Bool], [red, Bool]],
    [[red, Bool], [black, Bool], [white, Bool], [blue, Bool], [yellow, Bool]],
    [[yellow, Bool], [red, Bool] [black, Bool], [white, Bool], [blue, Bool]]]

The Wall interacts with the Pattern Lines, it only has the option of receiving tiles. The main methods:
##### initializeWall
```
initializeWall/1
initializeWall (Wall)
```
Generates a wall where all the squares have false, with no tiles set.

##### setColorWall
```
setColorWall / 4
setColorWall (Row, Color, Wall, WallR)
```
Given a row, the square of that wall color sets true.
##### scoreIJ 
```
scoreIJ / 4
scoreIJ (Wall, I, J, Score)
```
Given a square (I, J) on the Wall, the Score of placing a tile in that box.

### 5.2 Pattern Lines
The Pattern Lines is a structure that can be put in colored tiles (each line a single color), the row number is also the amount of tiles allowed. The structure of Pattern Lines is:
```[[Color, Row, AmountEmptyTiles] | LineaPatronLista]```
	
The Pattern Lines interact with the Factories, the Center, the Wall, the Floor and the Cover. It receives tiles from the Factories and Center, and gives tiles to the Wall, Cover and Floor. The main methods:

##### initializePatternLines
```
initializePatternLines/1
initializePatternLines (PatternLines)
```
Initialize a Pattern of a Player, with the 5 rows with noColor and number of gaps in all.

##### moveTilePatternToWallCover
```
moveTilePatternToWallCover / 8
moveTilePatternToWallCover (Wall, Cover, PatterLine, Score, WallR, CoverR, PatterLineR, ScoreR)
```
Move a completed Pattern Line to the Wall and the remaining tiles to the Cover and return the Score for putting that tile on the Wall.

##### moveTilePatternToFloorCover
```
moveTilePatternToFloorCover / 9
moveTilePatternToFloorCover (PatterLine, Cover, Floor, Color, CantColor, Row, PatterLineR, CoverR, FloorR)
```
Move some tiles of one color to the specific pattern line and the remaining ones go to the floor or to the top.
### 5.3 Floor
The Floor is a structure that can be placed with colored tiles (each space only one tile), there is a penalty for using them and if there are more tiles to discard than can be on the Floor, they are placed on the Cover. The structure of the Floor is:
```
[[Color | ColorsList]
```
The ground interacts with the Pattern Lines, and the Cover. It is emptied only at the end of the game. The main methods:
##### setFloorColor
```
setFloorColor/5
setFloorColor (Floor, Cover, Color, FloorR, CoverR)
```
Put a tile on the Floor, if it is full to the Cover.
##### scoreTotalFloor
```
scoreTotalFloor/ 2
scoreTotalFloor (Floor, Score)
```
Gives the total score to be subtracted from the number of tiles on the Floor.

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
