% start/1
start([[clear, a], [on, a, table], [clear, d], [on, d, b], [on, b, table], [clear, c], [on, c, table]]).

% goal/1
goal([[clear, a], [on, a, b], [on, b, c], [on, c, d], [on, d, table]]).

% findClearBlocks/2
% Clause 1: Holds true when clear has all blocks that are clear in the state.
findClearBlocks(STATE, CLEAR):-
    findall(X, (
        member(M, STATE),
        length(M, 2),
        M = [clear, X]
    ), CLEAR).

% remove/3
% Clause 1: Returns tail if the head is the element to remove.
remove(X, [X | T], T).

% Clause 2: If head is not the element to remove, recursively remove element from tail.
remove(X, [H | T], [H | O]):-
    remove(X, T, O).


% findBlockOn/3
% Clause 1: Holds true when ON is the block/table on which BLOCK is in STATE
findBlockOn(BLOCK, STATE, ON):-
    member(M, STATE),
    length(M, 3),
    M = [on, BLOCK, ON].

% move/4
% Clause 1: Fail when the block to move is on table and is to be moved on to table.
move(TO_MOVE, 'table', STATE, _):-
    findBlockOn(TO_MOVE, STATE, 'table'),
    !,
    fail.

% Clause 2: Holds true when block to move is moved on to table and the block below is cleared.
move(TO_MOVE, 'table', STATE, STATE2):-
    findBlockOn(TO_MOVE, STATE, ON),
    ON \= 'table',
    remove([on, TO_MOVE, ON], STATE, INT),
    append(INT, [[on, TO_MOVE, 'table'], [clear, ON]], STATE2).

% Clause 3: Holds true when block to move is on table and is placed on another block and
% the block it was placed on is removed from clear.
move(TO_MOVE, PLACE_ON, STATE, STATE2):-
    PLACE_ON \= 'table',
    findBlockOn(TO_MOVE, STATE, 'table'),
    remove([on, TO_MOVE, 'table'], STATE, INT),
    remove([clear, PLACE_ON], INT, INT2),
    append(INT2, [[on, TO_MOVE, PLACE_ON]], STATE2).

% Clause 4: Holds true when block to move is placed on another block and block below is cleared and
% the block it was placed on is removed from clear.
move(TO_MOVE, PLACE_ON, STATE, STATE2):-
    PLACE_ON \= 'table',
    findBlockOn(TO_MOVE, STATE, ON),
    ON \= 'table',
    remove([on, TO_MOVE, ON], STATE, INT),
    remove([clear, PLACE_ON], INT, INT2),
    append(INT2, [[on, TO_MOVE, PLACE_ON], [clear, ON]], STATE2).

% notYetVisited/2
% Clause 1: Holds true when the path so far is empty.
notYetVisited(_, []).

% Clause 2: Recursively checks the tail of path so far is head is not equal to state.
notYetVisited(STATE, [HPATH | TPATH]):-
    STATE \= HPATH,
    notYetVisited(STATE, TPATH).

% dfs/4
% Clause 1: Returns empty move when current state is goal state.
dfs(GOAL, GOAL, _, [], []).

% Clause 2: Recursively search for goal state by choosing next move such that the block to
% move is a clear block and the block to move on is also clear or the table, the two blocks
% are not same and the move does not result in a state already seen.
dfs(STATE, GOAL, PATH_SO_FAR, MOVES, STATES):-
    findClearBlocks(STATE, TO_MOVE_LIST),
    append(TO_MOVE_LIST, ['table'], PLACE_ON_LIST),
    member(TO_MOVE, TO_MOVE_LIST),
    member(PLACE_ON, PLACE_ON_LIST),
    TO_MOVE \= PLACE_ON,
    move(TO_MOVE, PLACE_ON, STATE, STATE2),
    sort(STATE2, SSTATE2),
    notYetVisited(SSTATE2, [STATE | PATH_SO_FAR]),
    dfs(SSTATE2, GOAL, [STATE | PATH_SO_FAR], TMOVES, TSTATES),
    append([[on, TO_MOVE, PLACE_ON]], TMOVES, MOVES),
    append([STATE], TSTATES, STATES).


% getMoves/3
% Clause 1: Holds true when MOVES holds the moves to be made in order to get from start state
% to goal state.
getMoves(STATES, MOVES):-
    start(START),
    sort(START, SSTART),
    goal(GOAL),
    sort(GOAL, SGOAL),
    dfs(SSTART, SGOAL, [], MOVES, STATES).
