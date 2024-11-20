findClearBlocks(STATE, CLEAR):-
    findall(X, (
        member(M, STATE),
        length(M, 2),
        M = [clear, X]
    ), CLEAR).

remove(X, [X | T], T).

remove(X, [H | T], [H | O]):-
    remove(X, T, O).


findBlockOn(BLOCK, STATE, ON):-
    member(M, STATE),
    length(M, 3),
    M = [on, BLOCK, ON].

move(TO_MOVE, 'table', STATE, _):-
    findBlockOn(TO_MOVE, STATE, 'table'),
    !,
    fail.

move(TO_MOVE, 'table', STATE, STATE2):-
    findBlockOn(TO_MOVE, STATE, ON),
    ON \= 'table',
    remove([on, TO_MOVE, ON], STATE, INT),
    append(INT, [[on, TO_MOVE, 'table'], [clear, ON]], STATE2).

move(TO_MOVE, PLACE_ON, STATE, STATE2):-
    PLACE_ON \= 'table',
    findBlockOn(TO_MOVE, STATE, 'table'),
    remove([on, TO_MOVE, 'table'], STATE, INT),
    remove([clear, PLACE_ON], INT, INT2),
    append(INT2, [[on, TO_MOVE, PLACE_ON]], STATE2).

move(TO_MOVE, PLACE_ON, STATE, STATE2):-
    PLACE_ON \= 'table',
    findBlockOn(TO_MOVE, STATE, ON),
    ON \= 'table',
    remove([on, TO_MOVE, ON], STATE, INT),
    remove([clear, PLACE_ON], INT, INT2),
    append(INT2, [[on, TO_MOVE, PLACE_ON], [clear, ON]], STATE2).

notYetVisited(_, []).

notYetVisited(STATE, [HPATH | TPATH]):-
    STATE \= HPATH,
    notYetVisited(STATE, TPATH).

dfs(GOAL, GOAL, _, []).

dfs(STATE, GOAL, PATH_SO_FAR, MOVES):-
    findClearBlocks(STATE, TO_MOVE_LIST),
    append(TO_MOVE_LIST, ['table'], PLACE_ON_LIST),
    member(TO_MOVE, TO_MOVE_LIST),
    member(PLACE_ON, PLACE_ON_LIST),
    TO_MOVE \= PLACE_ON,
    move(TO_MOVE, PLACE_ON, STATE, STATE2),
    sort(STATE2, SSTATE2),
    notYetVisited(SSTATE2, [STATE | PATH_SO_FAR]),
    dfs(SSTATE2, GOAL, [STATE | PATH_SO_FAR], TMOVES),
    append([[on, TO_MOVE, PLACE_ON]], TMOVES, MOVES).


moves(START, GOAL, MOVES):-
    sort(START, SSTART),
    sort(GOAL, SGOAL),
    dfs(SSTART, SGOAL, [], MOVES).
