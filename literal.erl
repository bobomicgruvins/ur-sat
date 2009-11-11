-module(literal).
-compile(export_all).

%% This is the "literal" module. All operations on the ADT "literal"
%% are provided by functions in this module.

%% WARNING WARNING: THIS IS CURRENTLY UNUSED.

%% THIS IS A PLANNED REFACTORING

-record(lit,
	{signed,
	 %% true if this literal is not(x), false if it is just x.
	 variable,
	 %% the underlying variable.
	 id
	 %% a signed integer: we can use this to look up what is
	 %% watching the literal
	}).

%% 
new({Variable, IsSigned, ID}) ->
    case IsSigned of
	true -> #lit{variable = Variable, signed = IsSigned, id = ID};
	false -> #lit{variable = Variable, signed = IsSigned, id = 2*ID}
    end.

signed(L) ->
    L#lit.signed.

variable(L) ->
    L#lit.variable.

negate(L) ->
    L#lit{signed = not(L#lit.signed), id = -(L#lit.id)}.

id(L) ->
    L#lit.id.

true_check(Literals) ->
    %%if any of the literals is just the "true" literal, return
    %%trivial_success: the clause can be satisfied by any assignment.
    lists:any(fun(X) -> X#lit.variable == true end, Literals).

parity_check(Literals) ->		      
    %% if the literals p and not(p) occur in the clause, then
    %% it is obvious that the clause is satisfiable under ANY
    %% assignment of all variables.
    {NegativeLits, PositiveLits} = lists:partition(fun(X) -> X#lit.signed end, Literals),
    CrossProduct = [ {X,Y} || X<-NegativeLits, Y<-PositiveLits],
    lists:any(fun({A,B}) -> A#lit.variable == B#lit.variable end, CrossProduct). 

remove_false_constants(Literals) ->
    lists:filter(fun(X) -> X#lit.variable == false end, Literals).
