%*****************%
%*** Strategy ****%
%*****************%
:-["Center.pl"].
:-["Factory.pl"].
:-["Player.pl"].

%selectStrategy / 7
%selectStrategy (Player, Factorys, Center, PatternRowR, TakeCenterBoolR, ColorR, FactorySelectR)
%This method is in charge of using the strategy that is defined for the Player.
selectStrategy ([Wall, PatternLines, Floor, Score, Strategy], Factorys, Center, PatternRowR, TakeCenterBoolR, ColorR, FactorySelectR): -
allPlays (Player, Factorys, Center, PlayListR), strategy (Strategy, PlayListR, Play).

%strategy / 3
%strategy (Strategy, PlayListR, Play).
%Strategy 0 first, strategy 1 is random, strategy 2 is gluttonous.
strategy (0, [Play | PlayListR], Play): - !.
strategy (1, PlayList, PlayR): - lenght (PlayList, N), random (0, N, M), nth0 (M, PlayList, PlayR),!.
strategy (2, PlayList, PlayR): - sort (4, @> =, PlayList], [PlayR | PlayListR]): - !.

%greedyStrategy / 7
%greedyStrategy (Player, Factorys, Center, PatternRowR, TakeCenterBoolR, ColorR, FactorySelecR)
%strategy that returns the place where to catch the tiles (Fabicaso or Center), Color to Pick and row of the pattern where to play.
greedyStrategy (Player, Factorys, Center, PatternRowR, TakeCenterBoolR, ColorR, PlaceR): -
append (Factorys, Center, Places),
tryEveryPlace (Places, [PlaceR, PatternRowR, ColorR, Punt]),
whatPlace (Place, Factorys, Center, TakeCenterBoolR).

%allPlays / 4
%allPlays (Player, Factorys, Center, PlayListR)
%all possible and valid moves
allPlays ([Wall, PatternLines, Floor, Score, Strategy], Factorys, Center, PlayListR): -
append (Factorys, Center, Places), tryEveryPlace (Places, Wall, Floor, PlayListsR).


%whatPlace / 4
%whatPlace (Place, Factorys, Center, TakeCenterBoolR).
%Says if Place is a Factory or Center.
whatPlace (Place, _, Place, true): - !.
whatPlace (_, _, _, false): - !.


%tryEveryPlace / 4
%tryEveryPlace (PossiblePlaceList, Wall, Floor, PlayLists, PlayListsR)
%For each of the places to take tile (Factory and Center), it returns which is the best row and color selection with that selection based on the Score
tryEveryPlace ([], _, _, []): - !.
tryEveryPlace ([PossiblePlace | PossiblePlaceList], Wall, Floor, [Play | PlayListR]): -
tryRows (PossiblePlace, Wall, Floor, Play),
tryEveryPlace (PossiblePlace, Wall, Floor, PlayListR).
    

%tryRows / 6
%tryRows (Place, Wall, Floor, PlayListR)
%Given a place (Factory or Center) say vual is the row that gives the most Score.
tryRows (Place, Wall, Floor, PlayListR): -
    tryColors (Place, Wall, 1, Floor, PlayList1),
    tryColors (Place, Wall, 2, Floor, PlayList2),
    tryColors (Place, Wall, 3, Floor, PlayList3),
    tryColors (Place, Wall, 4, Floor, PlayList4),
    tryColors (Place, Wall, 5, Floor, PlayList5),
    append5 (PlayList1, PlayList2, PlayList3, PlayList4, PlayList5, PlayListR).
    

%tryColors / 6
%tryColors (Place, Wall, Row, ColorR, Floor, PlayListR)
%Given a place (Factory or Center) and a row, saying vual is the color that gives the most Score.
tryColors (Place, Wall, Row, Floor, PlayListR): -
    itCan (Place, Wall, Row, blue, Floor, Could1, Punt1),
    itCan (Place, Wall, Row, yellow, Floor, Could2, Punt2),
    itCan (Place, Wall, Row, white, Floor, Could3, Punt3),
    itCan (Place, Wall, Row, black, Floor, Could4, Punt4),
    itCan (Place, Wall, Row, red, Floor, Could5, Punt5),
    addPlay (Place, Row, blue, Point1, Could1, List1),
    addPlay (Place, Row, yellow, Punt2, Could2, List2),
    addPlay (Place, Row, white, Punt3, Could3, List3),
    addPlay (Place, Row, black, Point4, Could4, List4),
    addPlay (Place, Row, red, Point5, Could5, List5),
    append5 (List1, List2, List3, List4, List5, PlayListR).
 
append5 (List1, List2, List3, List4, List5, LR): - append (List1, List2, ListT1), append (ListT1, List3, ListT2), append (ListT2, List4, ListT3), append (Listt3, List5, LR ).

addPlay (_, _, _, _, 0, []): - !.
addPlay (Place, Row, Color, Score, 0, [Place, Row, Color, Score]): - !.


%itCan / 7
%itCan (Place, Wall, Row, Color, Floor, Can, ScoreR)
%Score given a place to take tiles and put them in a row
itCan (Place, Wall, [noColor, Row, Row], Color, Floor, 1, ScoreR): - cantTileColorFactory (Place, Color, Cant), CantEmptyR is max (0, Row-Cant), CantLeftOver is max (0, Cant-Row), calculatePlay (CantEmpty, CantLeftOver, Wall, Row, Color, ScoreR),!.
itCan (Place, Wall, [Color, Row, CantEmpty], Color, Floor, 1, ScoreR): - cantTileColorFactory (Place, Color, Cant), CantEmptyR is max (0, CantEmpty-Cant), CantLeftOver is max (0, Cant-CantEmpty), calculatePlay (CantEmpty, CantLeftOver, Wall, Row, Color, ScoreR),!.
itCan (_, _, [OtherColor, _, _], Color, _, 0,0): - !.

%Auxiliary method to calculate the Score of the move.
calculatePlay (0, CantLeftOver, Wall, Floor, Row, Color, ScoreR): - I is Row-1, ColorPositionIJ (Wall, I, J, Color, _), scoreIJ (Wall, I, J, Score), lenght ( Floor, N), M is min (N + CantLeftOver, 7), scoreFloor (M, P), ScoreR is Score + P,!.
calculatePlay (_, _, _, _, _, _, 0): - !.