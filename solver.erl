-module(solver).
-compile(export_all).
-include_lib("records.hrl").

%% Private Functions:
%% search(Conflict,Solver)
%% search(true,S) ->
    


%% propogate(#solver{propQ = PropQ} = S) ->
%%     %% Returns either no_conflict, or a conflict clause
%%     case queue:is_empty(PropQ) of
%% 	false -> Literal = queue:out(PropQ),
%% 		 Watches = get_watches(Literal),
%% 		 process
	    


%% Public Interface:
		       
new(VarCount, ClauseCount) ->
    #solver{watches = array:new(2*VarCount,[]),
	    constraints = array:new(ClauseCount,[]),
	    assignments = array:new(VarCount,[{default,undefined}]),
	    var_dlevels = array:new(VarCount,[]),
	    reason = array:new(VarCount,[]),
	    propQ = queue:new()}.

make_constraint(Type, S, ArgBundle) ->
    {Type, Constraint} = Type:new(S, ArgBundle),
    Constraint.

add_constraints(Type, ArgBundles, #solver{constraints = Constraints} = S) ->
    code:ensure_loaded(Type),
    NewConstraints = array:map(fun(I, B) -> make_constraint(Type, S, B) end, ArgBundles),
    S#solver{constraints = NewConstraints}.



%%:make_constraint/3,
%% S#solver{constraints = array:map(fun(ArgBundle) ->
%% 					     {Type, Constraint} = Type:new(S, ArgBundle),
%% 					     Constraint end, 
%% 				     ArgBundles)}.
 
add_watch(L, Constraint, #solver{watches = Watches} = S) ->
    LitID = literal:id(L),
    %% need to get current value of watches:literalID
    case ets:lookup(Watches,LitID) of
	[] -> ets:insert(Watches,{LitID,[Constraint]});
	CurrentWatches -> ets:insert(Watches,{LitID,[Constraint|CurrentWatches]})
    end.

enqueue(L, FromClause, S) ->
    case value(L, S) of
	false -> conflict;
	true -> true;
	undefined -> store_fact(L, FromClause, S)
    end.
		
	
store_fact(P, FromClause, #solver{assignments = A, reason = R,
				  decision_level = D, trail = T,
				  propQ = Q, var_dlevels = VDs} = S) ->
    Var = literal:variable(P),

    {ok, S#solver{assignments = array:set(Var, not(literal:signed(P)), A),
		  reason = array:set(Var, FromClause, R),
		  decision_level = array:set(Var, D, VDs),
		  trail = [P|T], propQ = queue:in(P, Q)}}.


value(L, #solver{assignments = A} = S) ->
    array:get(L#lit.variable, A).


bumpClause(Clause, S) ->
    %% a PLACEHOLDER: none of the activity heuristic is implemented yet
    true.

bumpVarsOf(Literals, S) ->
    %% a PLACEHOLDER: none of the activity heuristic is implemented yet
    true.

%%  21:24 < valross> mogglefrange, code:ensure_loaded(modulename)  ?
%%  21:24 < yrashk> mogglefrange: see erl -man code
    
