-module(driver).
-compile(export_all).

%% Use this module to call any parsing functions and start the solver.

run_solver(File) ->
    {VarCount, ClauseCount, Clauses} = cnf:parseCNF(File),
    S = solver:new(),
    solver:add_constraints(clause, Clauses, S),
    solver:run(S).
