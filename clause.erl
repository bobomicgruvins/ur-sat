-module(clause).
-compile(export_all).
-include_lib("records.hrl").
						
new(S, {Literals, false}) ->
    case normalize(Literals) of
	trivial_success -> trivial_success;
	{literals, NormalizedLiterals} -> insert_clause(NormalizedLiterals, false, S);
	[] -> lolwut
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
    %%    TaggedLiterals = lists:map(fun(L) -> L#lit{id=make_ref(),clause=ClauseID} end, Literals), 
    NewClause = #clause{id = ClauseID, literals = array:from_list(Literals)},

    case Learnt of 
	true -> solver:bumpClause(NewClause,S),
		solver:bumpVarsOf(Literals,S);
	false -> nevermind
    end,

    solver:add_watch(literal:negate(array:get(0,NewClause#clause.literals)),NewClause,S),
    solver:add_watch(literal:negate(array:get(1,NewClause#clause.literals)),NewClause,S),
    {clause, NewClause}.

pick_watch(Literals) ->
    %% return a re-ordering of literals according to some heuristic.
    %% TODO: obviously, we don't do much here right now. implement
    %% this later
    Literals.

normalize(Literals) ->
    case literal:true_check(Literals) or literal:parity_check(Literals) of
	true -> trivial_success;
	false -> remove_dupes(literal:remove_false_constants(Literals))
    end.
    
remove_dupes(Literals) ->
    %%the "set" datatype doesn't allow duplicates
    sets:to_list(sets:from_list(Literals)).




%% The Propogate machienary

%% propogate(#clause{literals = Literals} = Clause, Literal, S) ->
    
%%     EnsuredLits = case array:get(0, Literals) of
%% 		      negate_literal(Literal) -> 
			  
    



%% to use make_ref or not to use make-ref?
    %% Some utilities:

negate_literal(#lit{sign = OldSign} = Literal) ->
    Literal#lit{sign = not(OldSign)}.
