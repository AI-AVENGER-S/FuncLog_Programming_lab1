subject(bio).
subject(chem).
subject(hist).
subject(math).

all_subjects([bio, chem, hist, math]).

combination(0, _, []).
combination(N, [H|T], [H|Comb]) :-
    N > 0,
    N1 is N - 1,
    combination(N1, T, Comb).
combination(N, [_|T], Comb) :-
    N > 0,
    combination(N, T, Comb).

check_stmt(Goal, true) :- call(Goal), !.
check_stmt(_, false).

count_true([], 0).
count_true([true|T], N) :- count_true(T, N1), N is N1 + 1.
count_true([false|T], N) :- count_true(T, N).


herman_stmts(D, G, O, [S1, S2, S3, S4]) :-
    % дима - единственный, кто любит историю
    check_stmt((member(hist, D), \+ member(hist, G), \+ member(hist, O)), S1),
    % олег и я увлекаемся одними и теми же предметами
    check_stmt(O == G, S2),
    % мы все считаем биологию интереснейшей
    check_stmt((member(bio, D), member(bio, G), member(bio, O)), S3),
    % двое из нас любят и химию, и биологию
    check_stmt((
        findall(P, (member(P, [D, G, O]), member(chem, P), member(bio, P)), People),
        length(People, 2)
    ), S4).

oleg_stmts(D, G, O, [S1, S2, S3, S4]) :-
    % нам очень нравится математика
    check_stmt((member(math, D), member(math, G), member(math, O)), S1),
    % герман - завзятый историк
    check_stmt(member(hist, G), S2),
    % в одном из увлечений мы расходимся с димой
    check_stmt((intersection(O, D, Inter), length(Inter, 2)), S3),
    % герман и дима любят химию
    check_stmt((member(chem, G), member(chem, D)), S4).

dima_stmts(D, G, O, [S1, S2, S3, S4]) :-
    % есть только один предмет, который любим мы все
    check_stmt((intersection(D, G, I1), intersection(I1, O, I2), length(I2, 1)), S1),
    % математикой увлекаюсь я один
    check_stmt((member(math, D), \+ member(math, G), \+ member(math, O)), S2),
    % каждый из нас любит разное сочетание дисциплин (все наборы уникальны)
    check_stmt((D \= G, D \= O, G \= O), S3),
    % олег ошибается говоря, что герман и я увлекаемся химией
    check_stmt(\+ (member(chem, G), member(chem, D)), S4).


solve(Dima, Herman, Oleg) :-
    all_subjects(Subjs),
    
    combination(3, Subjs, Dima),
    combination(3, Subjs, Herman),
    combination(3, Subjs, Oleg),
    
    herman_stmts(Dima, Herman, Oleg, H_List),
    count_true(H_List, 2),
    
    oleg_stmts(Dima, Herman, Oleg, O_List),
    count_true(O_List, 2),
    
    dima_stmts(Dima, Herman, Oleg, D_List),
    count_true(D_List, 2).

start :-
    write('Ищу решения'), nl,
    findall([D, G, O], solve(D, G, O), Solutions),
    length(Solutions, Count),
    write('Решений: '), write(Count), nl, nl,
    print_solutions(Solutions).

print_solutions([]).
print_solutions([[D, G, O]|T]) :-
    write('Дима любит: '), write(D), nl,
    write('Герман любит : '), write(G), nl,
    write('Олег любит: '), write(O), nl,
    write('-----------------------------'), nl,
    print_solutions(T).