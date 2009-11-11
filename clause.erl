-module(clause).
-compile(export_all).
-include_lib("records.hrl").
						
new(S, {Literals, false}) ->
    case normalize(Literals) of
	trivial_success -> S;
	{literals, NormalizedLiterals} -> insert_clause(NormalizedLiterals, false, S)
    end;
new(S, {Literals, true}) ->
    ReOrderedLits = pick_watch(Literals),
    %% pick the literal with the highest decision level
    insert_clause(ReOrderedLits, true, S).

insert_clause(Literals, _, S) when length(Literals) == 0 ->
    {conflict, S};
insert_clause(Literals, _, S) when length(Literals) == 1 ->
    {trivial_success, solver:enqueue(lists:nth(0,Literals),S)};
insert_clause(Literals, Learnt, S) ->
    ClauseID = make_ref(),
    NewClause = #clause{id = ClauseID, literals = array:from_list(Literals)},

    case Learnt of 
	true -> solver:bumpClause(NewClause,S),
		solver:bumpVarsOf(Literals,S);
	false -> nevermind
    end,

    FirstTwoLits = lists:sublist(Literals, 2),    
    NewS = lists:foldl(fun(X, Acc) -> solver:add_watch(literal:negate(X), NewClause) end, FirstTwoLits),
    
    {solver, solver:add_constraint(NewClause, NewS)}.

pick_watch(Literals) ->
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
