-module(cnf).
-compile(export_all).

readLines(File) ->
    {ok, Rest} = file:read_file(File),
    List = binary_to_list(Rest),
    Lines = string:tokens(List, "\n").
   
parseCNF(File) ->
    Lines = readLines(File),
    ["p", "cnf", VarCount_temp, ClauseCount_temp]= string:tokens(lists:nth(1, Lines), "\s"),
    {VarCount, _} = string:to_integer(VarCount_temp),
    {ClauseCount, _} = string:to_integer(ClauseCount_temp),
    [Head|Tail]=Lines,
    Token_list=token_maker(Tail, []),
    Int_list=int_maker(Token_list, []).

int_maker([], Buildlist) ->
    Buildlist;

int_maker(List, Buildlist) ->
    [Head|Tail] = List,
    Integerlist = [int_makeraux(Head, [])],
    int_maker(Tail, Buildlist ++ Integerlist).

int_makeraux([], Buildlist) ->
    Buildlist; 
int_makeraux(List, Buildlist) ->
    Element=element(1, string:to_integer(lists:nth(1, List))),
    Buildlist_temp=Buildlist ++ [Element],
    [Head|Tail]=List,
    int_makeraux(Tail, Buildlist_temp).


token_maker([], Buildlist)->
    Buildlist;

token_maker(List, Buildlist)->
    [Head|Tail]=List,
    
    TokenHead = string:tokens(Head, "\s"),
    Leader = lists:nth(1, TokenHead),
    if
	Leader == "c" ->
	    token_maker(Tail, Buildlist);
	true ->
	    Buildlist_temp = Buildlist ++ [TokenHead],
	    token_maker(Tail, Buildlist_temp)
    end.
    
%% list of strings to lists of space-seperated strings

parseLines(Lines) ->   

    TokenLists = lists:map(fun(X) -> string:tokens(X, "\s") end,Lines),
    CommentsGone = lists:filter(fun(X) -> [H|T] = X, not("c" == H) end,TokenLists), 
    lists:map(fun(X) ->
		      lists:map(fun(Y) -> {I,_} = string:to_integer(Y), I end, X) end, CommentsGone).
				    
