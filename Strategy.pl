%*****************%
%*** Strategy ****%
%*****************%
:-["Center.pl"].
:-["Factory.pl"].
:-["Player.pl"].

%selectStrategy / 7
%selectStrategy (Player, Factorys, Center, PatternRowR, TakeCenterBoolR, ColorR, FactorySelectR)
%This method is in charge of using the strategy that is defined for the Player.
selectStrategy ([Wall, PatternLines, Floor, Score, Strategy], Factorys, Center, PatternRowR, TakeCenterBoolR, ColorR, FactorySelectR): -
allPlays (Player, Factorys, Center, PlayListR), strategy (Strategy, PlayListR, Play).

%strategy / 3
%strategy (Strategy, PlayListR, Play).
%Strategy 0 first, strategy 1 is random, strategy 2 is gluttonous.
strategy (0, [Play | PlayListR], Play): - !.
strategy (1, PlayList, PlayR): - lenght (PlayList, N), random (0, N, M), nth0 (M, PlayList, PlayR),!.
strategy (2, PlayList, PlayR): - sort (4, @> =, PlayList], [PlayR | PlayListR]): - !.
