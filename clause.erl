-module(clause).

-record(clause,
    {literals,
    activity=0,
    learnt}).

%% 

new(S,ArgBundle) ->
    {Literals, Learnt} = ArgBundle,
    Watches = S#solver.watches,
    ClauseID = make_ref(),

    if 
	not(Learnt) ->
	    %%if any of the literals is just the "true" literal,
	    %%return TRUE and don't bother adding this clause to the
	    %%constraintDB

	    %% if the literals p and not(p) occur in the clause, then
	    %% it is obvious that the clause is satisfiable under ANY
	    %% assignment of all variables, return TRUE and don't
	    %% bother adding it to the clause DB

	    Set = sets:from_list(PS),		
	    
	    %%remove dupes: the "set" datatype doesn't allow duplicates
	    
	    %remove all literals which are just the literal "FALSE"
	    %from the clause

    end,
    
    TaggedLiterals = lists:map(fun(L) -> L#lit{id=make_ref(),clause=ClauseID} end, Literals),

    lists:map(fun(X) -> ets:insert(Watches,{X#lit.id,[]}) end, IdentifiedLiterals),

    {ClauseID, NewClause}.			
			
			
    
%% to use make_ref or not to use make-ref?
