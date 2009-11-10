-module(clause).
-compile(export_all).
-include_lib("records.hrl").
						
new(S, {Literals, false}) ->
    case normalize(Literals) of
	trivial_success -> trivial_success;
	{literals, NormalizedLiterals} -> insert_clause(NormalizedLiterals, false, S)
    end;
new(S, {Literals, true}) ->
    ReOrderedLits = pick_watch(Literals),
    %% use a heuristic to pick a second literal to watch
    insert_clause(ReOrderedLits, true, S).

insert_clause(Literals, Learnt, S) when length(Literals) == 0 ->
    conflict;
insert_clause(Literals, Learnt, S) when length(Literals) == 1 ->
    solver:enqueue(lists:nth(0,Literals),S);
insert_clause(Literals, Learnt, S) ->
    ClauseID = make_ref(),
    TaggedLiterals = lists:map(fun(L) -> L#lit{id=make_ref(),clause=ClauseID} end, Literals), 
    NewClause = #clause{id = ClauseID, literals = array:from_list(TaggedLiterals)},

    case Learnt of 
	true -> solver:bumpClause(NewClause,S),
		solver:bumpVarsOf(TaggedLiterals,S);
	false -> nevermind
    end,

    solver:add_watch(array:get(0,NewClause#clause.literals),NewClause,S),
    solver:add_watch(array:get(1,NewClause#clause.literals),NewClause,S),
    {clause, ClauseID, NewClause}.

pick_watch(Literals) ->
    %% return a re-ordering of literals according to some heuristic.
    %% TODO: obviously, we don't do much here right now. implement
    %% this later
    Literals.

normalize(Literals) ->
    case true_check(Literals) or parity_check(literals) of
	true -> trivial_success;
	false -> remove_dupes(remove_false_constants(Literals))
    end.

true_check(Literals) ->
    %%if any of the literals is just the "true" literal, return
    %%trivial_success: the clause can be satisfied by any assignment.
    lists:any(fun(X) -> X#lit.variable == true end, Literals).

parity_check(Literals) ->		      
    %% if the literals p and not(p) occur in the clause, then
    %% it is obvious that the clause is satisfiable under ANY
    %% assignment of all variables.
    {NegativeLits, PositiveLits} = lists:partition(fun(X) -> X#lit.sign == false end, Literals),
    CrossProduct = [ {X,Y} || X<-NegativeLits, Y<-PositiveLits],
    list:any(fun({A,B}) -> A#lit.variable == A#lit.variable end, CrossProduct).    
    
remove_dupes(Literals) ->
    %%the "set" datatype doesn't allow duplicates
    sets:to_list(sets:from_list(Literals)).

remove_false_constants(Literals) ->
    lists:filter(fun(X) -> X#lit.variable == false end, Literals).


%% The Propogate machienary

propogate(#clause{literals = Literals} = Clause, Literal, S) ->
    
    


			 
    
%% to use make_ref or not to use make-ref?
