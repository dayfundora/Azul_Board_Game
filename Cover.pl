%*****************%
%******Cover******%
%*****************%

%initializeCover / 1
%initializeCover (Cover)
%Generates a cover (Cover) for the start of the game with 0 tiles of each color.
initializeCover ([[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]]).

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
