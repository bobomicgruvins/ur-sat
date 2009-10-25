-module(cnf).

readLines(File) ->
    {ok, Rest} = file:read_file(File),
    List = binary_to_list(Rest),
    Lines = string:tokens(List, "\n").

parseCNF(Clauses) ->
    
