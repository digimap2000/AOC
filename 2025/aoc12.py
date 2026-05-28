from ortools.sat.python import cp_model

def parse_and_solve(filename):
    model = cp_model.CpModel()
    vars = {}

    def get_var(name):
        if name not in vars:
            vars[name] = model.NewBoolVar(name)
        return vars[name]

    with open(filename) as f:
        for lineno, line in enumerate(f, 1):
            line = line.strip()
            if not line or line.startswith("#"):
                continue

            # Determine operator
            if "<=" in line:
                lhs, rhs = line.split("<=")
                op = "<="
            elif "=" in line:
                lhs, rhs = line.split("=")
                op = "="
            else:
                raise ValueError(f"Line {lineno}: no operator found")

            # Parse RHS
            try:
                rhs = int(rhs)
            except ValueError:
                raise ValueError(f"Line {lineno}: invalid RHS")

            # Parse LHS terms
            terms = lhs.split("+")
            expr = sum(get_var(t) for t in terms)

            # Add constraint
            if op == "<=":
                model.Add(expr <= rhs)
            else:
                model.Add(expr == rhs)

    # Solve
    solver = cp_model.CpSolver()

    solver.parameters.num_search_workers = 0  # use all cores
    solver.parameters.cp_model_presolve = True
    solver.parameters.linearization_level = 2
#    solver.parameters.restart_algorithm = cp_model.LUBY_RESTART
    solver.parameters.max_time_in_seconds = 3600  # unlimited
#    solver.parameters.log_search_progress = True    
    status = solver.Solve(model)

    print("Status:", solver.StatusName(status))

    if status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        print("\nSelected placements:")
        for name in sorted(vars):
            if solver.Value(vars[name]) == 1:
                print(name, "= 1")
    else:
        print("\nNo feasible solution found.")

if __name__ == "__main__":
    parse_and_solve("constraints.txt")
