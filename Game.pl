%*****************%
%******Game******%
%*****************%
:-["Bag.pl"].
:-["Center.pl"].
:-["Factory.pl"].
:-["Player.pl"].
:-["Cover.pl"].
:-["Strategy.pl"].

%initializeGame/1
%initializeGame(cantPlayers)
%Initialize a Game, this is the main, it only needs how many players (cantPlayers).
initializeGame(cantPlayers):-
 print('  Start Game '),
 prepareGame(cantPlayers,Players,Bag,Factories,Center,Cover),
 play(Players,Bag,Factories,Center,Cover,IsOver,PlayersT),
 extraPoints(PlayersT,PlayersR),
 getWinners(PlayersR,Winners).

%prepareGame/6
%prepareGame(cantPlayers,Players,Bag,Factories,Center,Cover)
%Is in charge of initializing the board (Players, Bag, Factories, Center)
prepareGame(cantPlayers,Players,Bag,Factories,Center,Cover):-
 print('  Initializing '),
 initializePlayers(cantPlayers,Players),
 initializeBag(BagT),
 initializeFactory(cantPlayers,BagT,Factories,BagR),
 print('  Factories Full'),
 initializeCover(Cover),
 initializeCenter(Center).

%play/6
%play(Players,Bag,Factories,Center,Cover,IsOver,PlayersR)
%This is where the game happens, each player plays, the rounds are repeated, until someone lines up.
play(Players,Bag,Factories,Center,Cover,1,Players):-print('  Game Over '),!.
play(Players,Bag,Factories,Center,Cover,0,PlayersR):-offertFactory(Players,Bag,Factories,Center,Cover,PlayersT,BagT,FactoriesT,CenterT,CoverT),
 tilingWalls(PlayersT,CoverT,PlayersS,CoverS), 
 prepareNextRound(PlayersS,BagT,FactoriesT,CenterT,CoverS,PlayersM,BagR,FactoriesR,CenterR,CoverR), 
 print('  The round is over ')
 play(PlayersM,BagR,FactoriesR,CenterR,CoverR,IsOver,PlayersR).

%offertFactory/10
%offertFactory(Players,Bag,Factories,Center,Cover,PlayersR,BagR,FactoriesR,CenterR,CoverR)
%Wrapper for round
offertFactory(Players,Bag,Factories,Center,Cover,PlayersR,BagR,FactoriesR,CenterR,CoverR):-round(Players,Bag,Factories,Center,Cover,PlayersR,BagR,FactoriesR,CenterR,CoverR,0).

%round/11
%round(Players,Bag,Factories,Center,Cover,PlayersR,BagR,FactoriesR,CenterR,CoverR,IsOverRonda)
%This is where the players decide their strategies and follow them, until the end of the round, without passing the tiles of the pattern lines to the wall, until the factories and center are empty.
round(Players,Bag,Factories,Center,Cover,Players,Bag,Factories,Center,Cover,1):!.
round([Player|PlayersList],Bag,Factories,Center,Cover,PlayersListR,BagR,FactoriesR,CenterR,CoverR,0):-playPlayer(Player,Bag,Factories,Center,Cover,PlayerT,BagT,FactoriesT,CenterT,CoverT),append(PlayersList,[PlayerT],PlayersListT),terminoRonda(FactoriesT,IsOverRonda),round(PlayersListT,BagT,FactoriesT,CenterT,CoverT,PlayersListR,BagR,FactoriesR,CenterR,CoverR,IsOverRonda).

%playPlayer/10
%playPlayer(Player,Bag,Factories,Center,Cover,PlayerR,BagR,FactoriesR,CenterR,CoverR)
%This is where a Player selects tiles and puts them on his board.
playPlayer(Player,Bag,Factories,Center,Cover,PlayerR,BagR,FactoriesR,CenterR,CoverR):-
selectStrategy(Player,Factories,Center,FilaPatronT,CogiCenterBoolT,ColorT,FactorySelecT),putStrategyBoard(Factories,Center,Bag,Cover,Player,FilaPatronT,CogiCenterBoolT,FactorySelecT,ColorT,FactoriesR,CenterR,BagR,CoverR,PlayerR).

%putStrategyBoard/14
%putStrategyBoard(Factories,Center,Bag,Cover,Player,Fila,CogerCenterBool,FactorySelec,Color,FactoriesR,CenterR,BagR,CoverR,PlayerR)
%After select the strategy, its selected the tile of the factory or center to the pattern linen la linea del patron seleccionada.
putStrategyBoard(Factories,Center,Bag,Cover,[Wall,PatternLines,Suelo,Score,Strategy],Fila,true,_,Color,Factories,CenterR,BagR,CoverR,[Wall,PatternLinesR,SueloR,ScoreR,Strategy]):-removeColorCenter(Center,Color,CenterT,CantColor), mueveAzulejoAPatronesSueloBag(PatternLines,Fila,Bag,Suelo,Color,CantColor,PatternLineR,BagR,SueloR),!.
putStrategyBoard(Factories,Center,Bag,Cover,[Wall,PatternLines,Suelo,Score,Strategy],Fila,false,FactorySelec,Color,FactoriesR,Center,BagR,CoverR,[Wall,PatternLinesR,SueloR,ScoreR,Strategy]):-removeColorFromFactory(Factories,FactorySelec,Center,CenterT,FactoriesT,Color,CantColor),moveTilePatternsFloorCover(PatternLines,Fila,Cover,Suelo,Color,CantColor,PatternLineR,CoverR,SueloR),!.

%tilingWalls/4
%tilingWalls(Players,Cover,PlayersR,CoverR)
%This is a wrapper of tiling, it ensures that each wall of each player is tiled (Players)
tilingWalls([],Cover,[],Cover):-print('Tilling Walls'),!.
tilingWalls([Player|PlayersList],Cover,[PlayerR|PlayersListR],CoverR):-tilling(Player,Cover,PlayerR,CoverT), tilingWalls(PlayersList,CoverT,PlayersListR,CoverR).

%tilling/4
%tilling(Player,Cover,PlayerR,CoverR)
%Move the lines filled with the players pattern lines to the wall, return the excess tiles to the top.
tilling([Wall,PatternLines,Suelo,Score,Strategy],Bag,[WallR,PatternLinesR,SueloR,ScoreR,Strategy],BagR):-moverPatternLinesLLenasWall(Wall,PatternLines,Bag,Score,WallR,PatternLinesR,BagT,ScoreT), scoreTotalFloor(Suelo,ScoreS), putFloorBag(BagT,Suelo,BagR), ScoreR is ScoreT-ScoreS.

%moveFullPatternLinesToWall/8
%moveFullPatternLinesToWall(Wall,PatternLines,Cover,Score,WallR,PatternLinesR,CoverR,ScoreT)
%checks each line of the PatternLines and if any is complete, marks the Wall, the remaining tiles go to the Cover and returns the score of putting the tiles on the Wall
moveFullPatternLinesToWall(Wall,[PatternLine|PatternLinesList],Cover,Score,WallR,[PatternLineR|PatternLinesListR],CoverR,ScoreR):-moveTilePatternWallCover(Wall,Cover,PatternLine,Score,WallT,CoverT,PatternLineT,ScoreS),ScoreT is Score+ScoreS, moveFullPatternLinesToWall(WallT,PatternLinesList,CoverT,ScoreT,WallR,PatternLinesListR,CoverR,ScoreR).

%prepareNextRound/6
%prepareNextRound(Players,Bag,Factories,Center,Cover,PlayersR,BagR,FactoriesR,CenterR,CoverR)
%Make the necessary preparations to start a new round.
%In this method is where players are ordered in this round.
prepareNextRound(Players,Bag,Factories,Center,Cover,PlayersR,BagR,FactoriesR,CenterR,CoverR):-lenght(Factories,N),CantAzulejos is N*4,bolsaSuficiente(Bag,CantAzulejos),initializeCover(Bag,Cover,BagT,CoverT),fillFactory(Factories,BagT,FactoriesR,BagR)

%extraPoints/2
%extraPoints(Players,PlayersR)
%After the strategy is selected, the factory or center tile selection is applied and placed on the selected pattern line.
extraPoints([],[]):-print('  Extra Points')!.
extraPoints([Player|PlayersList],[PlayerR|PlayersListR]):-puntoExtraPlayer(Player,PlayerR),extraPoints(PlayersList,PlayersListR).

%extraPoints/2
%extraPoints(Player,PlayerR)
%When a game is over, calculate the extra points if a player row, column or color was completed (Player)
extraPoints([Wall,PatternLines,Suelo,Score,Strategy],[Wall,PatternLines,Suelo,ScoreR,Strategy]):- pointsFullLines(Wall,PointsFullLines), pointsFullColumns(Wall,PuntosColumnasCompletas), pointsFullColors(Wall,PuntosColoresCompletos), ScoreR is pointsFullLines + PuntosColumnasCompletas + PuntosColoresCompletos.


%checkFull/2
%checkFull(Fila, Llena)
%LLena es 1 si la fila(Fila) esta llena en otro caso es 0
checkFull([[_,true],[_,true],[_,true],[_,true],[_,true]], 1) :- !.
checkFull(_, 0) :- !.

%pointsFullLines/2
%pointsFullLines(Wall,Score)
%Score depending on how many complete lines you have on the wall
pointsFullLines(Wall,PointsFullLines):-RowWall(0, Wall, F0), comprobarFila(F0, P0),RowWall(1, Wall, F1), comprobarFila(F1, P1),RowWall(2, Wall, F2), comprobarFila(F2, P2),RowWall(3, Wall, F3), comprobarFila(F3, P3),RowWall(4, Wall, F4), comprobarFila(F4, P4),Score is P0 + P1 + P2 + P3 + P4.

%pointsFullColumns/2
%pointsFullColumns(Wall,PointsFullColumns)
%Score depending on how many complete columns you have on the wall
pointsFullColumns(Wall,Score):-ColumnWall(0, Wall, C0), checkFull(C0, P0),ColumnWall(1, Wall, C1), checkFull(C1, P1),ColumnWall(2, Wall, C2), checkFull(C2, P2),ColumnWall(3, Wall, C3), checkFull(C3, P3),ColumnWall(4, Wall, C4), checkFull(C4, P4),Score is P0 + P1 + P2 + P3 + P4.

    
%pointsFullColors/2
%pointsFullColors(Wall,PointsFullColors)
%Score depending on how many complete colors you have on the wall
pointsFullColors(Wall,Score):-ColorWall(blue, Wall, C0), checkFull(C0, P0),ColorWall(yellow, Wall, C1), checkFull(C1, P1),ColorWall(white, Wall, C2), checkFull(C2, P2),ColorWall(black, Wall, C3), checkFull(C3, P3), ColorWall(red, Wall, C4), checkFull(C4, P4),Score is P0 + P1 + P2 + P3 + P4.

%getWinners/2
%getWinners(PlayersR,Winners)
%Return players with best score
getWinners(PlayersR,Winner):-sort(4,@>=,Players,[Winner|WinnersLista]),print('Winner:'),nl,nl,printPlayer(Winner),nl,nl.

%printPlayer/1
%printPlayer(Player)
%Pint data of the Player
printPlayer([Wall,PatternLines,Suelo,Score,Strategy]):-print('  Score: '),print(Score),nl,print('--------'),nl.
