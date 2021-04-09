%*****************%
%*****PLAYER******%
%*****************%


%inicializePlayer/1
%inicializePlayer([Wall,PatternLine,Floor,Score,Strategy])
%Initializes a Player, with his board (Wall, Floor, Pattern Lines, Score) and a number that represents the strategy taken by the player.
inicializePlayer([Wall,PatternLine,[],0,Strategy]):-inicializeWall(Wall),initializePatternLines(PatternLine),giveStrategy(Strategy).


%inicializePlayers/2
%inicializePlayers(N,PlayersList)
%Inicialize N Players(between 2 and 4).
inicializePlayers(0,[]).
inicializePlayers(N,[Player|PlayersList]):-M is min(N,4),inicializePlayer(Player), N2 is M-1, inicializePlayers(N2,PlayersList).
