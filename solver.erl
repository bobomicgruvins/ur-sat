-module(solver).
-compile(export_all).
-include_lib("records.hrl").

add_constraints(Type, ArgBundles, #solver{constraints = Constraints} = S) ->
    code:ensure_loaded(Type),
    lists:map(fun(ArgBundle) -> 
		      {clause, ConstraintID, Constraint} = Type:new(S, ArgBundle),
		      ets:insert(Constraints, {ConstraintID, Constraint}) end, 
	      ArgBundles).
		       
new() ->
    #solver{watches = ets:new(watches, []), 
	    constraints = ets:new(constraints, []), 
	    propQ = queue:new()}.


%%  21:24 < valross> mogglefrange, code:ensure_loaded(modulename)  ?
%%  21:24 < yrashk> mogglefrange: see erl -man code
    



 
