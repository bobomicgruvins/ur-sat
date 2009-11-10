-record(solver,
	{constraints,
	 variableOrder = false,
	 propogation = false,
	 assignments = false,
	 watches = false,				
	 %% array(array(constraint)): for each literal 'p', a list of constraints watching
	 %% 'p'. These constraints must be inspected when 'p' becomes true.
	 %% -------------------------------------------------
	 undos = false,					
	 %% array(array(constraint)): for each variable 'x', a list of constraints that need to be
	 %% updated when 'x' becomes unbound in backtracking 
	 %% --------------------------------------------------
	 propQ = false}).
         %% queue: propogation queue

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

-record(lit,
	{sign = true,
	 clause = 0,
	 variable = 0,
	 id = 0}).

%% NOTE: If a literal is simply the "true," or "false" literal, the
%% "variable" field of a literal record is the boolean value "true" or
%% "false", not a reference to any variable.

-record(clause,
	{literals = [],
	 activity = 0,
	 id = 0,
	 learnt = false}).
