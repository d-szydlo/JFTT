#!/usr/bin/python3

import sys

def generate_pi(pattern):
    m = len(pattern)
    pi_function = [0 for i in range(m)]
    pi_function[0] = -1
    k = -1
    for q in range(1, m):
        while k >= 0 and pattern[k+1] != pattern[q]:
            k = pi_function[k]
        if pattern[k+1] == pattern[q]:
            k += 1
        pi_function[q] = k
    return list(map(lambda x: x+1, pi_function))

def match_pattern(pattern, line, m, pi_function):
    matches = []
    n = len(line)
    q = 0
    for i in range(n):
        while q > 0 and pattern[q] != line[i]:
            q = pi_function[q-1]
        if pattern[q] == line[i]:
            q += 1
        if q == m:
            matches.append(i+2-m)
            q = pi_function[q-1]
    return matches

def find_matches():
    pattern = sys.argv[1]
    m = len(pattern)
    pi_function = generate_pi(pattern)
    c = 1
    with open(sys.argv[2], "r") as file:
        for line in file.readlines():
            matches = match_pattern(pattern, line.strip("\n"), m, pi_function)
            print("Line", c, "- matches found at columns", matches)
            c += 1

def main():
    find_matches()

if __name__ == "__main__":
    main()
