%*****************%
%****** Bag ******%
%*****************%

%initializeBag / 1
%initializeBag (Bag)
%Generates a bag (Bag) for the beginning of the game with 20 tiles of each color.
initializeBag ([[blue, 20], [yellow, 20], [white, 20], [black, 20], [red, 20]]).

%makeColorsList / 2
%makeColorsList (Bag, List)
%From a bag (Bag) with its characteristic structure, generate a list (List) with all the tiles in the bag, it will be a list of colors.
makeColorsList ([], []): -!
makeColorsList ([[Color, 0] | BagL], List): - makeColorsList (BagL, List),!.
makeColorsList ([[Color, CantColor] | BagL], List): - append (List, [Color]), CantColorR is CantColor-1, makeColorsList ([[Color, CantColorR] | BagL], List).

%takeTileRandomBag / 3
%takeTileRandomBag (Bag, Color, BagR)
%Select a random (Color) tile from the bag (Bag)
takeTileRandomBag (Bag, Color, BagR): - makeColorsList (Bag, List), lenght (List, L), random (0, L, I), nth0 (I, List, Color), putNColorBag (Bag, Color, BagR) .

%putTileFactory / 3
%putTileFactory (Factory, Color, FactoryR)
%Adds a random (Color) tile from the factory.
putTileFactory ([[Color, CantColor] | FactoryL], Color, [[Color, CantColorR] | FactoryLR]): - CantColorR is CantColor + 1,!.
putTileFactory ([[OtherColor, CantOtroColor] | FactoryL], Color, [[OtherColor, CantOtroColor] | FactoryLR]): - putTileFactory (FactoryL, Color, FactoryLR).

%takeNTilesBagForFactory / 5
%takeNTilesBagForFactory (Bag, Factory, Quantity, ManufactureR, BagR)
%Select Qty of random tiles from factory bag.
takeNTilesBagForFactory (Bag, Factory, 0, FactoryR, BagR): - !.
takeNTilesBagForFactory ([[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]], Factory, _, Factory, [[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]]): - !.
takeNTilesBagForFactory (Bag, Factory, Qty, FactoryR, BagR]): - takeTileRandomBag (Bag, Color, BagT), putTileFactory (Factory, Color, FactoryT), CantR is Cant-1, takeNTilesBagForFactory (BagT, FactoryT, CantR, FactoryR, BagR ).

%putNColorBag / 4
%putNColorBag (Bag, Color, Quantity, BagR)
%Puts N Color tiles in the bag.
putNColorBag ([[Color, QtyColor] | BagL], Color, Qty, [[Color, QtyColorR] | BagLR]): - QtyColorR is QtyColor + Qty,!.
putNColorBag ([[OtherColor, QtyOtherColor] | BagL], Color, Qty, [[OtherColor, QtyOtherColor] | BagLR]): - putNColorBag (BagL, Color, Qty, BagLR).

%putNColorsBag / 3
%putNColorsBag (Bag, ListColorCant, BagR)
%Puts a list of colors (with their respective quantities in the bag color tiles Color in the bag.
putNColorsBag (Bag, [], Bag): - !.
putNColorsBag (Bag, [[Color, Qty], L], BagR): - putNColorBag (Bag, Color, Qty, BagT), putNColorsBag (BagT, L, BagR).

%putFloorBag / 3
%putFloorBag (Bag, ColorList, BagR)
%Puts a list of colors (without quantities) in the bag.
putFloorBag (Bag, [], Bag): -!
putFloorBag (Bag, [Color | ColorList], BagR): - putNColorBag (Bag, Color, 1, BagT), putFloorBag (BagT, ListColor, BagR).