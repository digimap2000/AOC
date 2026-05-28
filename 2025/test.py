from ortools.sat.python import cp_model

def main():
    model = cp_model.CpModel()

    # Simple binary variables
    x = model.NewBoolVar('x')
    y = model.NewBoolVar('y')
    z = model.NewBoolVar('z')

    # Constraints
    model.Add(x + y <= 1)
    model.Add(y + z <= 1)
    model.Add(x + z >= 1)

    # Solve
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = 5
    solver.parameters.log_search_progress = True

    status = solver.Solve(model)

    print("\nStatus:", solver.StatusName(status))
    print("x =", solver.Value(x))
    print("y =", solver.Value(y))
    print("z =", solver.Value(z))

if __name__ == "__main__":
    main()
