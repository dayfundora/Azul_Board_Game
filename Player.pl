%*****************%
%*****PLAYER******%
%*****************%
:-["Cover.pl"].

%inicializePlayer/1
%inicializePlayer([Wall,PatternLine,Floor,Score,Strategy])
%Initializes a Player, with his board (Wall, Floor, Pattern Lines, Score) and a number that represents the strategy taken by the player.
inicializePlayer([Wall,PatternLine,[],0,Strategy]):-inicializeWall(Wall),initializePatternLines(PatternLine),giveStrategy(Strategy).


%inicializePlayers/2
%inicializePlayers(N,PlayersList)
%Inicialize N Players(between 2 and 4).
inicializePlayers(0,[]).
inicializePlayers(N,[Player|PlayersList]):-M is min(N,4),inicializePlayer(Player), N2 is M-1, inicializePlayers(N2,PlayersList).


%_________________%
%       Wall      %
%_________________%

%inicializeWall/1
%inicializeWall(Wall)
%Initializes a players wall, which is a fixed structure with a given order and a variable to say if the square is occupied or not.
inicializeWall([[[blue,falso],[yellow,falso],[red,falso],[black,falso],[white,falso]],
                 [[white,falso],[blue,falso],[yellow,falso],[red,falso],[black,falso]],
                 [[black,falso],[white,falso],[blue,falso],[yellow,falso],[red,falso]],
                 [[red,falso],[black,falso],[white,falso],[blue,falso],[yellow,falso]],
                 [[yellow,falso],[red,falso][black,falso],[white,falso],[blue,falso]]).

%ColorPositionIJ/5
%ColorPositionIJ(Wall,I,J,Color,IsIn)
%Given the wall (Wall), know if exist a tile of color Color in position I, J
ColorPositionIJ(Wall,I,J,Color,IsIn):-nth0(I,Wall,Row),nth0(J,Row,[Color,IsIn]).


%RowWall/3
%RowWall(I,Wall,Row)
%Gives the row (Row) i-th (I) of the wall (Wall).
RowWall(I,Wall,Row):-nth0(I,Wall,Row).

%ColumnWall/3
%ColumnWall(J,Wall,Column)
%Gives the column (Column) j-th (J) of the wall (Wall).
ColumnWall(J,Wall,[[C1,IsIn1],[C2,IsIn2],[C3,IsIn3],[C4,IsIn4],[C5,IsIn5]]):-ColorPositionIJ(Wall,0,J,C1,IsIn1),ColorPositionIJ(Wall,1,J,C2,IsIn2),ColorPositionIJ(Wall,2,J,C3,IsIn3),ColorPositionIJ(Wall,3,J,C4,IsIn4),ColorPositionIJ(Wall,4,J,C5,IsIn5).

%RowWall/3
%ColorWall(Color,Wall,Line)
%Give the Line (Line) with the color tiles (Color) of the wall (Wall).
ColorWall(Color,Wall,[[Color,IsIn1],[Color,IsIn2],[Color,IsIn3],[Color,IsIn4],[Color,IsIn5]]):-ColorPositionIJ(Wall,0,_,Color,IsIn1),ColorPositionIJ(Wall,1,_,Color,IsIn2),ColorPositionIJ(Wall,2,_,Color,IsIn3),ColorPositionIJ(Wall,3,_,Color,IsIn4),ColorPositionIJ(Wall,4,_,Color,IsIn5).

%putColorRow/3
%putColorRow(Color,Row,RowR)
%Given a row (Row) puts the tile of that color (Color).
putColorRow(Color,[[Color,false]|L],[[Color,true]|L]):-!.
putColorRow(Color,[OtherColor|L],[OtherColor|LR]):-putColorRow(Color,L,LR).

%putColorWall/4
%putColorWall(Row,Color,Wall,WallR)
%Given a row (Row) puts the tile of that color (Color) of the wall (Wall).
putColorWall(0,Color,[Row|L],[RowR|L]):-putColorRow(Color,Row,RowR),!.
putColorWall(F,Color,[Row|L],[Row|LR]):-N is F-1,putColorWall(N,Color,L,LR).

%scoreIJ/4
%scoreIJ(Wall,I,J,Score)
% Given a tile (I, J) on the wall (Wall), the score (Score) of placing a tile on that square.
scoreIJ(Wall,I,J,Score):-Left is I-1, Right is I+1, Top is J-1, Bot is J+1,
                                   adjacentLeft(I, Left, Wall, 0, CantLeft),
                                   adjacentRight(I, Right, Wall, 0, CantRight),
                                   adjacentTop(Top, J, Wall, 0, CantTop),
                                   adjacentBottom(Bot, J, Wall, 0, CantBottom),
                                   Score is CantLeft + CantRight + CantTop + CantBottom + 1.

%adjacentLeft/5
%adjacentLeft(I,J,Wall,Score,ScoreR)
%Given a tile (I, J) on the wall (Wall), the score (Score) of his adjacent on the left.
adjacentLeft(_, -1, _, Score, Score) :- !.
adjacentLeft(I, J, Wall, Score, ScoreR) :-ColorPositionIJ(Wall, I, J,_, true), J1 is J-1, ScoreT is Score + 1, !, adjacentLeft(I, J1, Wall, ScoreT, ScoreR).
adjacentLeft(_, _, _, Score, Score) :- !.

%adjacentRight/5
%adjacentRight(I,J,Wall,Score,ScoreR)
% Given a tile (I, J) on the wall (Wall), the score (Score) of his adjacent on the right.
adjacentRight(_, 5, _, Score, Score) :- !.
adjacentRight(I, J, Wall, Score, ScoreR) :-ColorPositionIJ(Wall, I, J,_, true), J1 is J+1, ScoreT is Score + 1, !, adjacentRight(I, J1, Wall, ScoreT, ScoreR).
adjacentRight(_, _, _, Score, Score) :- !.

%adjacentTop/5
%adjacentTop(I,J,Wall,Score,ScoreR)
%Given a tile (I, J) on the wall (Wall), the score (Score) of his adjacent on the top.
adjacentTop(-1, _, _, Score, Score) :- !.
adjacentTop(I, J, Wall, Score, ScoreR) :-ColorPositionIJ(Wall, I, J,_, true), I1 is I-1, ScoreT is Score + 1, !, adjacentTop(I1, J, Wall, ScoreT, ScoreR).
adjacentTop(_, _, _, Score, Score) :- !.


%adjacentBottom/5
%adjacentBottom(I,J,Wall,Score,ScoreR)
%Given a tile (I, J) on the wall (Wall), the score (Score) of his adjacent on the bottom.
adjacentBottom(5, _, _, Score, Score) :- !.
adjacentBottom(I, J, Wall, Score, ScoreR) :-ColorPositionIJ(Wall, I, J,_, true), I1 is I+1, ScoreT is Score + 1, !, adjacentBottom(I1, J, Wall, ScoreT, ScoreR).
adjacentBottom(_, _, _, Score, Score) :- !.


%_________________%
%       Floor     %
%_________________%

%The Floor has 7 squares, each one has negative points, and a square cannot be used without all the previous ones being occupied
%The 1 and 2 value -1, the 3, 4 and 5 value -3, the 6 and 7 value -3.
scoreFloor(0,0).
scoreFloor(1,1).
scoreFloor(2,2).
scoreFloor(3,4).
scoreFloor(4,6).
scoreFloor(5,8).
scoreFloor(6,11).
scoreFloor(7,14).

%setFloorColor/5
%setFloorColor(Floor,Cover,Color,FloorR,CoverR)
%Wrapper to setFloorColorCover
setFloorColor(Floor,Cover,Color,FloorR,CoverR):-lenght(Floor,N),setFloorColorCover(Floor,Cover,Color,N,FloorR,CoverR).


%setFloorColorCover/6
%setFloorColorCover(Floor,Cover,Color,N,FloorR,CoverR)
%put a color (Color) on the floor, if it is full (N) it is put on the cover
setFloorColorCover(Floor,Cover,Color,7,Floor,CoverR):-putNColorsCover(Cover,Color,1,CoverR),!.
setFloorColorCover(Floor,Cover,Color,_,FloorR,Cover):-append(Floor,[Color],FloorR).

%setFloorColorsCover/5
%setFloorColorsCover(Floor,Cover,[Color,CantColor],FloorR,CoverR)
%put N tiles of color (Color) on the floor
setFloorColorsCover(Floor,Cover,[_,0],Floor,Cover):-!.
setFloorColorsCover(Floor,Cover,[Color,CantColor],,FloorR,CoverR):-setFloorColor(Floor,Cover,Color,FloorT,CoverT),CantColorRis CantColor-1,setFloorColorsCover(FloorT,CoverT,[Color,CantColorR],FloorR,CoverR).

%scoreTotalFloor/2
%scoreTotalFloor(Floor,Score)
%Gives the total scorethat must be subtracted by the number of tiles on the Floor
scoreTotalFloor(Floor,Score):-lenght(Floor,N),scoreFloor(N,Score).


%__________________%
%   Pattern Lines  %
%__________________%

%initializePatternLines/1
%initializePatternLines(PatternLines)
%Initialize a Player Pattern, which is a fixed structure, each line has [Color, Row, EmptyTileQuantity].
initializePatternLines([[noColor,1,1],[noColor,2,2],[noColor,3,3],[noColor,4,4],[noColor,5,5]]).

%canPutPattern/5
%canPutPattern(PatternLine,Wall,[Color,CantColor],LeftOverTile,LeftOverSpace)
%When putting a quantity of tiles (CantColor) of color (Color) in a line of the pattern, how many tiles are left over and how much space is left.
canPutPattern([Color,Row,CantEmpty],Wall,[Color,CantColor],LeftOverTile,LeftOverSpace):- I is Row-1, ColorPositionIJ(Wall,I,J,Color,0),!,LeftOverTile is max(0,CantColor-CantEmpty),LeftOverSpace is max(0,CantEmpty-CantColor).
canPutPattern([noColor,Row,Row],Wall,[Color,CantColor],LeftOverTile,LeftOverSpace):- I is Row-1, ColorPositionIJ(Wall,I,J,Color,0),!,LeftOverTile is max(0,CantColor-Row),LeftOverSpace is max(0,Row-CantColor).

%moveTilePattern/5
%moveTilePattern(PatternLine,[Color,CantColor],PatternLineR)
%puts an amount of tiles (CantColor) of color (Color) in a pattern line.
moveTilePattern([_,Row,Row],[Color,CantColor],[Color,Row,CantEmpty]):-CantEmpty is N-CantColor,!.
moveTilePattern([Color,N,CantEmpty],[Color,CantColor],[Color,Row,CantEmptyR]):-CantEmptyR is CantEmpty-CantColor,!.

%moveTilePatternWallCover/5
%moveTilePatternWallCover(Wall,Cover,PatternLine,Score,WallR,CoverR,PatternLineR,ScoreR)
%moves a completed Pattern Line to the Wall and the remaining tiles to the Cover and returns the score for putting that tile on the Wall.
moveTilePatternWallCover(Wall,Cover,[Color,Row,0],Score,WallR,CoverR,PatternLineR,ScoreR):-I is Row-1,ColorPositionIJ(Wall,I,J,Color,true),putColorWall(Row,Color,Wall,WallT), putNColorCover(Cover,Color,I,CoverR),scoreIJ(Wall,I,J,ScoreT),ScoreR is ScoreT+Score.

%moveTilePatternFloorCover/9
%moveTilePatternFloorCover(PatternLine,Cover,Floor,Color,CantColor,Row,PatternLineR,CoverR,FloorR)
%moves some tiles (CantColor) of a color Color to the Pattern Line number (Row) and those that remain go to the Floor or to the Cover
moveTilePatternFloorCover([_,Row,CantEmpty],Cover,Floor,Color,CantColor,Row,PatternLineR,CoverR,FloorR):-CantPonerEnPatternLine is min(CantColor,CantEmpty),CantSobran is CantEmpty-CantPonerEnPatternLine, moveTilePattern([_,Row,CantEmpty],[Color,CantPonerEnPatternLine],PatternLineR),setFloorColorsCover(Floor,Cover,[Color,CantSobran],FloorR,CoverR).

%moveTilePatternsFloorCover/9
%moveTilePatternsFloorCover(PatternLine,Cover,Floor,Color,CantColor,Row,PatternLineR,CoverR,FloorR)
%moves some tiles (CantColor) of a color Color to the Pattern Line number (Row) and those that remain go to the Floor or to the Cover
moveTilePatternsFloorCover([],Cover,Floor,_,_,_,[],Cover,Floor):-!.
moveTilePatternsFloorCover([[AnyColor,OtherRow,CantEmpty]|PatternLineList],Cover,Floor,Color,CantColor,Row,[[AnyColor,OtherRow,CantEmpty]|PatternLineListR],CoverR,ScoreR):-moveTilePatternsFloorCover(PatternLineList,Cover,Floor,Color,CantColor,Row,PatternLineListR,CoverR,FloorR).
moveTilePatternsFloorCover([[AnyColor,Row,CantEmpty]|PatternLineList],Cover,Floor,Color,CantColor,Row,[[AnyColor,Row,CantEmptyR]|PatternLineList],CoverR,FloorR):-moveTilePatternFloorCover([AnyColor,Row,CantEmpty],Cover,Floor,Color,CantColor,[AnyColor,Row,CantEmptyR],CoverR,FloorR).
