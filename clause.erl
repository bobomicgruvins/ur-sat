-module(clause).
-compile(export_all).
-include_lib("records.hrl").
						
new(S, {Literals, false}) ->
    insert_clause(Literals, false, S).

new(S, {Literals, true}) ->
    ReOrderedLits = pick_watch(Literals),
    %% use a heuristic to pick a second literal to watch
    insert_clause(normalize(ReOrderedLits), true, S).

insert_clause(Literals, Learnt, S) when length(Literals) == 0 ->
    false;
insert_clause(Literals, Learnt, S) when length(Literals) == 1 ->
    solver:enqueue(array:get(0,Literals),S);
insert_clause(Literals, Learnt, #solver{watches = Watches} = S) ->
    ClauseID = make_ref(),
    TaggedLiterals = lists:map(fun(L) -> L#lit{id=make_ref(),clause=ClauseID} end, Literals), 
    lists:map(fun(X) -> ets:insert(Watches,{X#lit.id,[]}) end, TaggedLiterals),
    NewClause = #clause{id = ClauseID, literals = TaggedLiterals},
    {clause, ClauseID, NewClause}.

pick_watch(Literals) ->
    %% return a re-ordering of literals according to some heuristic.

normalize(Literals) ->
    %%if any of the literals is just the "true" literal,
    %%return TRUE and don't bother adding this clause to the
    %%constraintDB: it can be satisfied by any assignment
    %% use lists:any. 
    
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
