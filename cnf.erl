-module(cnf).
-compile(export_all).
%% -include_lib("records.hrl").

readLines(File) ->
    {ok, Rest} = file:read_file(File),
    List = binary_to_list(Rest),
    Lines = string:tokens(List, "\n").

%% list of strings to lists of space-seperated strings

linesToLists(Lines) ->   
    TokenLists = lists:map(fun(X) -> string:tokens(X, "\s") end,Lines),
    CommentsGone = lists:filter(fun(X) -> [H|T] = X, not("c" == H) end,TokenLists), 
    [ProblemStatement|Clauses] = CommentsGone,
    
    ConvertedClauses = 
	lists:map(
	  fun(X) ->
		  lists:map(fun(Y) -> {I,_} = string:to_integer(Y), I end, X) end, 
	  Clauses),

    {ProblemStatement, ConvertedClauses}.

%% ["p", "cnf", VarCount_temp, ClauseCount_temp]= string:tokens(lists:nth(1, Lines), "\s"),
%% {VarCount, _} = string:to_integer(VarCount_temp),
%% {ClauseCount, _} = string:to_integer(ClauseCount_temp),	


%% old code: from when we weren't hiding the implementation of literals as records
%% listToLits(List) ->
%%     lists:map(fun(X) -> #lit{variable=abs(X),sign=positivep(X)} end, List).
%% clausesToArgs(Lists) ->
%%     lists:map(fun listToLits/1, Lists).
%% ------------------------------------------------------------------------

%% We take in a list of signed integers, and convert it to a list of
%% tuples suitable for the literal:new(X) function.
prepare_literal_values(List) ->
    lists:map(fun(X) -> {abs(X), not(positivep(X)), X} end, List).

positivep(N) when N >= 0 ->
    true;
positivep(N) when N < 0 ->
    false.

parseCNF(File) ->
    Lines = readLines(File),
    {Problem, ClauseLists} = linesToLists(Lines),
    LiteralTuplesByClause = lists:map(fun prepare_literal_values/1, ClauseLists),
    LiteralsByClause = lists:map(
			 fun(X) -> lists:map(fun literal:new/1, X) end, 
			 LiteralTuplesByClause),
    {1, 5, LiteralsByClause}.
