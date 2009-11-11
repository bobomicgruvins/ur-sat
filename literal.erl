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

    

