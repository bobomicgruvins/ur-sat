-module(cnf).
-compile(export_all).

-record(lit,
	{sign=true,
	 variable=0,
	 id=0}).

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

listToLits(List) ->
    lists:map(fun(X) -> #lit{variable=abs(X),sign=positivep(X)} end, List).

clausesToArgs(Lists) ->
    lists:map(fun(X) -> listToLits(X) end, Lists).

positivep(N) when N >= 0 ->
    true;
positivep(N) when N < 0 ->
    false.
    
parseCNF(File) ->
    Lines = readLines(File),
    {Problem, Clauses} = linesToLists(Lines),
    clausesToArgs(Clauses).
