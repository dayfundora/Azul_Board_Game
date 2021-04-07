%*****************%
%*****CENTER******%
%*****************%


%initializeCenter / 1
%initializeCenter (Center)
%Generates a Center (Center) without any tiles.
initializeCenter ([[blue, 0], [yellow, 0], [white, 0], [black, 0], [red, 0]]).

%putCenterColor / 3
%putCenterColor (Center, Color, CenterR)
%Puts in the Center (Center) all the tiles of the same color (Color).
putCenterColor ([[Color, CantColor1] | CenterList], [Color, CantColor2], [[Color, CantColor] | CenterList]): - CantColor is CantColor1 + CantColor2,!.
putCenterColor ([[OtherColor, CantOtherColor] | CenterList], [Color, CantColor], [[OtherColor, CantOtherColor] | CenterListR]): - putCenterColor (CenterList, [Color, CantColor], CenterListR).

%putCenterColorList / 3
%putCenterColorList (Center, ColorList, CenterR)
%Puts in the Center (Center) all the tiles in the list (ColorList).
putCenterColorList (Center, [], Center): - !.
putCenterColorList (Center, [[Color, CantColor] | List], CenterR): - putCenterColor (Center, [Color, CantColor], CenterT), putCenterColorList (CenterT, List, CenterR).

%removeColorCenter / 3
%removeColorCenter (Center, Color, CenterR, CantColor)
%Removes all color tiles from the Center (Center).
removeColorCenter ([], _, []], 0): - !.
removeColorCenter ([[Color, CantColor] | CenterList], Color, [[Color, 0] | CenterList]], CantColor): - !.
removeColorCenter ([[OtherColor, CantOtherColor] | CenterList], Color, [[OtherColor, CantOtherColor] | CenterListR]], CantColor): - removeColorCenter (CenterList, Color, CenterListR, CantColor).