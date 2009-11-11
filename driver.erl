-module(driver).
-compile(export_all).

%% Use this module to call any parsing functions and start the solver.

run_solver(File) ->
    {VarCount, ClauseCount, LitLists} = cnf:parseCNF(File),
    S = solver:new(VarCount, ClauseCount),
    Clauses = [{LiteralList, false} || LiteralList <- LitLists],
    solver:add_constraints(clause, Clauses, S),
    S.
