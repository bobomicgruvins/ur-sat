-module(clause).

-record(clause,
    {literals,
    activity=0,
    learnt}).

%% 

new(S,ArgBundle) ->

    if 
	Learnt ->
	    Set = sets:from_list(PS),		%remove dupes
	    CleanedSet = sets:filter(is_false,Set)
    end,

    OldWatches = S#solver.watches,
    NewWatches = [|OldWatches]
	S_next = S#solver{watches = NewWatches}
