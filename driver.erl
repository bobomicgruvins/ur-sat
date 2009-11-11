-module(driver).
-compile(export_all).

%% Use this module to call any parsing functions and start the solver.

run_solver(File) ->
    {VarCount, ClauseCount, LitList} = cnf:parseCNF(File),
    S = solver:new(),
    Clauses = [{LiteralList, false} || LiteralList <- LitLists],
    solver:add_constraints(clause, lists:to_array(Clauses), S),
    S.
