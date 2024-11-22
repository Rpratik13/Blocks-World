inp = [['a' ], ['b'], ['c', 'd']]

state = []

for i in inp:
    for j in range(len(i)):
        if j == 0:
            state.append(['clear', i[j]])

        if j == len(i) - 1:
            state.append(['on', i[j], 'table'])
            continue

        state.append(['on', i[j], i[j + 1]])

print(state)
