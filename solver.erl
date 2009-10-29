-module(solver).
-export([add_constraints/2]).

-record(solver,
	{constraintDB,
	 variableOrder,
	 propogation,
	 assignments}).

-record(constraint_data_base,
	{constraints,				
	 %% array(constraint): constraint records
	 learnt_clauses,			
	 %% array(clause): learnt clauses
	 clause_increment,			
	 %% float: amount to bump by when a clause sees activity
	 clause_decay}).			
         %% float: factor by which to decay clause activity

-record(variable_ordering,
	{activity,				
	 %% array(float): indexed by variable id. activity level.
	 variable_increment,			
	 %% float: amount to bump by when a variable sees activity
	 variable_decay,			
	 %% float: factor by which to decay variable activity
	 ordering
	 %% array/list(?) : variables sorted by the valyes in "activity"
	}).

%% Note! Need to figure out how to implement the variableOrder public interface.

-record(propogation_rec,
	{watches,				
	 %% array(array(constraint)): for each literal 'p', a list of constraints watching
	 %% 'p'. These constraints must be inspected when 'p' becomes true.
	 %% -------------------------------------------------
	 undos,					
	 %% array(array(constraint)): for each variable 'x', a list of constraints that need to be
	 %% updated when 'x' becomes unbound in backtracking 
	 %% --------------------------------------------------
	 queue}).
	 %% array: propogation queue

-record(assignment_rec,
	{assigns,				
	 %% array(boolean): indexed by variable id, the current assignments.
	 trail,					
	 %% array: assignments in chronological order; of form {variable_id, assignment}
 	 trail_bounds, 				
	 %% array(int): indicies in 'trail' where the decision level changes
	 reasons,
	 %% array(constraints): indexed by variable id, the constraint that implied the value of a
	 %% variable
	 levels,				
	 %% array(int): indexed by variable id, the decison level it was assigned at.
	 root_level}).				


init_solver(S,Constraints)->
    S = #solver,
    init_solver(add_constraints(clause,ArgBundles,S)).

 
add_constraints(Type, ArgBundles,S#solver{Watches = watches, Constraints = constraints}) ->

    AddConstraint = fun(ArgBundle,S) ->
			    {ok, Constraint,S} = Type:new(S,X) end,

    lists:foldl(AddConstraint,S,ArgBundles),
    
    lists:map(fun(ArgBundle) -> ets:insert(Constraints,Type:new(S,ArgBundle)), ArgBundles).
		       


    
    


%%  21:24 < valross> mogglefrange, code:ensure_loaded(modulename)  ?
%%  21:24 < yrashk> mogglefrange: see erl -man code
    



 
