%*****************%
%*****Factory*****%
%*****************%


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
