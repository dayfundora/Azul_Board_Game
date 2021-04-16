%*****************%
%******Game******%
%*****************%
:-["Bag.pl"].
:-["Center.pl"].
:-["Factory.pl"].
:-["Player.pl"].
:-["Cover.pl"].
:-["Strategy.pl"].

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
