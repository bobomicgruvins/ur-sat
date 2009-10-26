-module(clause).

-record(clause,
    {literals,
    activity=0,
    learnt}).

%% 

new(PS,Learnt) ->
    if 
	Learnt ->
	    Set = sets:from_list(PS),		%remove dupes
	    CleanedSet = sets:filter(is_false,Set)
    end,
    
    

