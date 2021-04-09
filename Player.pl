%*****************%
%*****PLAYER******%
%*****************%


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
