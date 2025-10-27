my_length([], 0).
my_length([_|T], N) :- 
    my_length(T, N1), 
    N is N1 + 1.

my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

my_append([], L, L).
my_append([H|T], L, [H|R]) :- my_append(T, L, R).

my_remove(X, [X|T], T).
my_remove(X, [H|T], [H|R]) :- my_remove(X, T, R).

my_permute([], []).
my_permute(L, [X|P]) :- 
    my_remove(X, L, R), 
    my_permute(R, P).

my_sublist(S, L) :- my_append(_, S, R), my_append(R, _, L).


% способ 1: С использованием стандартных предикатов
remove_last_std(List, Result) :-
    my_append(Result, [_], List).

% способ 2: без использования стандартных предикатов
remove_last_custom([_], []).
remove_last_custom([H|T], [H|Result]) :-
    remove_last_custom(T, Result).

% способ 1: с использованием стандартных предикатов
count_even_std(List, Count) :-
    findall(X, (my_member(X, List), X mod 2 =:= 0), Evens),
    my_length(Evens, Count).

% способ 2: без использования стандартных предикатов
count_even_custom([], 0).
count_even_custom([H|T], Count) :-
    count_even_custom(T, Count1),
    (H mod 2 =:= 0 -> Count is Count1 + 1; Count = Count1).

% удалить последний элемент и посчитать четные числа в результате
example_usage(List, ResultList, EvenCount) :-
    remove_last_std(List, ResultList),
    count_even_std(ResultList, EvenCount).