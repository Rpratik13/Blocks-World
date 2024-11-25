initial_state = [["b", "a"], ["c"], ["d", "e", "f"], ["h", "g", "i", "j"]]
goal_state = [["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]]


def parse(inp):
    state = []

    for i in inp:
        for j in range(len(i)):
            if j == 0:
                state.append(["clear", i[j]])

            if j == len(i) - 1:
                state.append(["on", i[j], "table"])
                continue

            state.append(["on", i[j], i[j + 1]])

    return f"[[{'], ['.join(map(lambda x: ', '.join(x), state))}]]"


print("Initial State")
print(parse(initial_state))

print("\nGoal State")
print(parse(goal_state))
