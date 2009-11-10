-module(clause).
-compile(export_all).
-include_lib("records.hrl").
						
new(S, {Literals, false}) ->
    case normalize(Literals) of
	trivial_success -> trivial_success;
	{literals, NormalizedLiterals} -> insert_clause(NormalizedLiterals, false, S)
    end.

new(S, {Literals, true}) ->
    ReOrderedLits = pick_watch(Literals),
    %% use a heuristic to pick a second literal to watch
    insert_clause(ReOrderedLits, true, S).

insert_clause(Literals, Learnt, S) when length(Literals) == 0 ->
    conflict;
insert_clause(Literals, Learnt, S) when length(Literals) == 1 ->
    solver:enqueue(array:get(0,Literals),S);
insert_clause(Literals, Learnt, #solver{watches = Watches} = S) ->
    ClauseID = make_ref(),
    TaggedLiterals = lists:map(fun(L) -> L#lit{id=make_ref(),clause=ClauseID} end, Literals), 
    lists:map(fun(X) -> ets:insert(Watches,{X#lit.id,[]}) end, TaggedLiterals),
    NewClause = #clause{id = ClauseID, literals = TaggedLiterals},
    {clause, ClauseID, NewClause}.

%replace the direct ets call with a call to solver:addwatch(Solver,Literal,Constraint)

add_watch(Literal, Constraint, #solver{watches = Watches} = S) ->
    %% need to get current value of watches:literalID
    
    case ets:lookup(Watches,Literal#lit.id) of
	

    ets:insert(Watches, {X#lit.id,[]}

pick_watch(Literals) ->
    %% return a re-ordering of literals according to some heuristic.

true_check(Literals) ->
    lists:any(fun(X) -> 
		      

normalize(Literals) ->
    %%if any of the literals is just the "true" literal,
    %%return TRUE and don't bother adding this clause to the
    %%constraintDB: it can be satisfied by any assignment
    %% use lists:any. 
    Literals = case true_check(Literals) or parity_check(literals) of
		   true -> trivial_success;
		   false -> %remove dupes, remove false literals
	       end,
    
    
    
    %% if the literals p and not(p) occur in the clause, then
    %% it is obvious that the clause is satisfiable under ANY
    %% assignment of all variables, return TRUE and don't
    %% bother adding it to the clause DB. lists:partition into
    %% true and false signed literals, then take the powerset
    %% using a list comprehension. test those tuples for the
    %% same underlying variable using lists:any
    
    Set = sets:from_list(Literals).

    %%remove dupes: the "set" datatype doesn't allow duplicates

    %%remove all literals which are just the literal "FALSE"
    %%from the clause
    
%% to use make_ref or not to use make-ref?
