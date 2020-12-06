#!/usr/bin/python3

import sys

def generate_delta(alphabet, pattern, index):
    m = len(pattern)
    delta = [[0 for i in range(m+1)] for j in range(len(alphabet))]
    for q in range(m+1):
        for a in alphabet:
            k = min(m+1, q+2)
            k -= 1
            while not (pattern[:q]+a).endswith(pattern[:k]):
                k -= 1
            delta[index[a]][q] = k
    return delta

def matcher(line, delta, m, index, alphabet):
    n = len(line)
    q = 0
    matches = []
    for i in range(n):
        if line[i] in alphabet:
            q = delta[index[line[i]]][q]
        else:
            q = 0
        if q == m:
            matches.append(i+2-m)
    return matches

def find_matches():
    pattern = sys.argv[1]
    alphabet = list(set(pattern))
    index = {a: alphabet.index(a) for a in alphabet}
    delta = generate_delta(alphabet, pattern, index)
    m = len(pattern)
    c = 1
    with open(sys.argv[2], 'r') as file:
        for line in file.readlines():
            matches = matcher(line.strip('\n'), delta, m, index, alphabet)
            print("Line", c, "- matches found at columns", matches)
            c += 1

def main():
    find_matches()

if __name__ == "__main__":
    main()
