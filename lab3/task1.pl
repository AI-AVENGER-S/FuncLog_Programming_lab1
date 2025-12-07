start_State([w, w, w, e, b, b, b]).

goal_State([b, b, b, e, w, w, w]).


move(State, Next) :-
    append(Left, [w, e | Right], State),
    append(Left, [e, w | Right], Next).

move(State, Next) :-
    append(Left, [e, b | Right], State),
    append(Left, [b, e | Right], Next).

move(State, Next) :-
    append(Left, [w, X, e | Right], State),
    append(Left, [e, X, w | Right], Next).

move(State, Next) :-
    append(Left, [e, X, b | Right], State),
    append(Left, [b, X, e | Right], Next).


solve_dfs(Path) :-
    start_State(Start),
    dfs(Start, [Start], Path).

dfs(State, Visited, Path) :-
    goal_State(State),
    reverse(Visited, Path).

dfs(State, Visited, Path) :-
    move(State, Next),
    \+ member(Next, Visited),
    dfs(Next, [Next | Visited], Path).


% поиск в ширину
solve_bfs(Path) :-
    start_State(Start),
    bfs([[Start]], Path).

bfs([[State | RestPath] | _], Path) :-
    goal_State(State),
    reverse([State | RestPath], Path).

bfs([Path | Queue], SolutionPath) :-
    Path = [State | _],
    findall(
        [Next | Path],
        (move(State, Next), \+ member(Next, Path)),
        NewPaths
    ),
    append(Queue, NewPaths, NewQueue),
    bfs(NewQueue, SolutionPath).


% поиск с итеративным погружением
solve_ids(Path) :-
    start_State(Start),
    between(1, 100, Limit),
    depth_limited_dfs(Start, [Start], Path, Limit).

depth_limited_dfs(State, Visited, Path, _) :-
    goal_State(State),
    reverse(Visited, Path).

depth_limited_dfs(State, Visited, Path, Limit) :-
    length(Visited, Len),
    Len < Limit,
    move(State, Next),
    \+ member(Next, Visited),
    depth_limited_dfs(Next, [Next | Visited], Path, Limit).


% -----------------------
print_solution([]).
print_solution([H|T]) :-
    writeln(H),
    print_solution(T).


benchmark(Strategy, Path) :-
    statistics(walltime, [_]),
    
    call(Strategy, Path),
    
    statistics(walltime, [_, ExecutionTime]),
    
    length(Path, Length), 
    
    format('~n--- Решено с помощью ~w ---', [Strategy]),
    format('~nЗатраченное время: ~w мс', [ExecutionTime]),
    format('~nДлина пути: ~d шагов~n', [Length]).