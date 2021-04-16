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
