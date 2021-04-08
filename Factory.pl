%*****************%
%*****Factory*****%
%*****************%
:-["Bag.pl"].


%initializeFactory / 1
%initializeFactory (Factory)
%Generates an empty Factory (Factory), it does not have any tiles.
initializeFactory ([[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]]).

%cantFactoryXPlayers / 2
%cantFactoryXPlayers (CantPlayers, CantFactories).
%given a number of players (CantPlayers), gives a number of Factories (CantFactories)
cantFactoryXPlayers (2,5)
cantFactoryXPlayers (3,7)
cantFactoryXPlayers (4,9)

%quantityTilesFactoryColor / 3
%quantityTilesFactoryColor (Factory, Color, Qty)
%Gives the quantity (Qty) of tiles of one color (Color) in a Factory.
quantityTilesFactoryColor ([[Color, CantColor] | List], Color, CantColor): - !.
quantityTilesFactoryColor ([[OtherColor, CantOtroColor] | List], Color, CantColor): - quantityTilesFactoryColor (List, Color, CantColor).


%initializeFactories / 4
%initializeFactories (CantPlayers, Bag, Factories, BagR).
%given a number of players (CantPlayers) the necessary Factories (Factories) are created
initializeFactories (CantPlayers, Factories): - cantFactoryXPlayers (CantPlayers, CantFactories), makeNFactories (CantPlayers, Bag, Factories, BagR).

%fillFactory / 2
%fillFactory (Factories, Bag, FactoriesR, BagR).
%Full of tiles each Factory (Factories).
fillFactory ([], Bag, [], Bag): - !.
fillFactory ([Factory | FactoriesList], Bag, [FactoryR | FactoriesListR], BagR): - takeNTilesBagForFactory (Bag, Factory, 4, FactoryR, BagT), fillFactory (FactoriesList, BagT, FactoriesListR, BagR).

%makeNFactories / 4
%makeNFactories (N, Bag, FactoriesR, BagR)
%Generates a list of N Factories (FactoriesR) with 4 elements in each.
makeNFactories (0, Bag, [], Bag): - !.
makeNFactories (N, Bag, [Factory | FactoriesL], BagR): - initializeFactory (FactoryT), takeNTilesBagForFactory (Bag, FactoryT, 4, Factory, BagT), N2 is N-1, makeNFactories (N2, BagT, FactoriesL, BagR) .
