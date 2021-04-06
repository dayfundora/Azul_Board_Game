%*****************%
%******Cover******%
%*****************%
:-["Bag.pl"].

%initializeCover / 1
%initializeCover (Cover)
%Generates a cover (Cover) for the start of the game with 0 tiles of each color.
initializeCover ([[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]]).

%initializeCover / 4
%initializeCover (Bag, Cover, BagR, CoverR, NeedBool)
%Puts all tiles from the cover (Cover) into the Bag, if needed.
initializeCover (Bag, Cover, Bag, Cover, 0): - !.
initializeCover (Bag, [[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]], Bag, [[blue, 0], [yellow, 0] , [white, 0], [black, 0], [red, 0]], 1): - !.
initializeCover (Bag, [[Color, CantColor] | CoverList], BagR, [[Color, 0] | CoverListR], 1): - putNColorsBag (Bag, Color, CantColor, BagT), initializeCover (BagT, CoverList, BagR, CoverListR ).

%putNColorCover / 4
%putNColorCover (Cover, Color, Quantity, CoverR)
%Puts N Blue Eyes Color on the Cover (Cover).
putNColorCover ([[Color, CantColor] | CoverL], Color, Cant, [[Color, CantColorR] | CoverLR]): - CantColorR is CantColor + Cant,!.
putNColorCover ([[OtherColor, CantOtherColor] | CoverL], Color, Cant, [[OtherColor, CantOtherColor] | CoverLR]): - putNColorCover (CoverL, Color, Cant, CoverLR).

%putNColorsCover / 3
%putNColorsCover (Cover, ListColorCant, CoverR)
%Put a list of colors (with their respective Quantityes) in the Cover.
putNColorsCover (Cover, [], Cover): - !.
putNColorsCover (Cover, [[Color, Qty], L], CoverR): - putNColorCover (Cover, Color, Qty, CoverT), putNColorsCover (CoverT, L, CoverR).
