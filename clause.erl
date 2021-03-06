-module(clause).
-compile(export_all).
-include_lib("records.hrl").
						
new(S, {Literals, false}) ->
    case normalize(Literals) of
	trivial_success -> S; %% if it just a true literal or if it has a lteral and its negation. 
	{literals, NormalizedLiterals} -> insert_clause(NormalizedLiterals, false, S)  %%not trival. 
    end;
new(S, {Literals, true}) ->
    ReOrderedLits = pick_watch(Literals),
    %% pick the literal with the highest decision level
    insert_clause(ReOrderedLits, true, S).

insert_clause(Literals, _, S) when length(Literals) == 0 -> 
    {conflict, S};						%%if the clause is empty return conflict
insert_clause(Literals, _, S) when length(Literals) == 1 ->
    {ok, solver:enqueue(lists:nth(0,Literals), unit,S)};             %% if the length is do unit propagation. bug fixed here we need another argument to enque.
insert_clause(Literals, Learnt, S) ->
    ClauseID = make_ref(),
    NewClause = #clause{id = ClauseID, literals = array:from_list(Literals)},     %% no unit clause, pick two watched literals, the first two. 

    case Learnt of 
	true -> solver:bumpClause(NewClause,S),
		solver:bumpVarsOf(Literals,S);
	false -> nevermind
    end,

    FirstTwoLits = lists:sublist(Literals, 2),    								    %% 
    NewS = lists:foldl(fun(X, Acc) -> solver:add_watch(literal:negate(X), NewClause, Acc) end, FirstTwoLits, S),         %% This adds two watched literals ot the 																	solver object 
    
    {solver, solver:add_constraint(NewClause, NewS)}.                              %% return solver

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
