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