-module(solver).
-compile(export_all).
-include_lib("records.hrl").

%% Private Functions:
%% search(Conflict,Solver)
search(true,S) ->
    


propogate(#solver{propQ = PropQ} = S) ->
    %% Returns either no_conflict, or a conflict clause
    case queue:is_empty(PropQ) of
	false -> Literal = queue:out(PropQ),
		 Watches = get_watches(Literal),
		 process
	    


%% Public Interface:
		       
new() ->
    #solver{watches = ets:new(watches, []), 
	    constraints = ets:new(constraints, []), 
	    propQ = queue:new()}.

add_constraints(Type, ArgBundles, #solver{constraints = Constraints} = S) ->
    code:ensure_loaded(Type),
    lists:map(fun(ArgBundle) -> 
		      {Type, ConstraintID, Constraint} = Type:new(S, ArgBundle),
		      ets:insert(Constraints, {ConstraintID, {Type, Constraint}}) end, 
	      ArgBundles).

add_watch(Literal, Constraint, #solver{watches = Watches} = S) ->
    %% need to get current value of watches:literalID
    case ets:lookup(Watches,Literal#lit.id) of
	[] -> ets:insert(Watches,{Literal#lit.id,[Constraint]});
	CurrentWatches ->ets:insert(Watches,{Literal#lit.id,[Constraint|CurrentWatches]})
    end.

bumpClause(Clause,S) ->
    %% a PLACEHOLDER: none of the activity heuristic is implemented yet
    true.

bumpVarsOf(Literals,S) ->
    %% a PLACEHOLDER: none of the activity heuristic is implemented yet
    true.

%%  21:24 < valross> mogglefrange, code:ensure_loaded(modulename)  ?
%%  21:24 < yrashk> mogglefrange: see erl -man code
    



 
