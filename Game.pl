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
