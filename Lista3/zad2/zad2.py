#!/usr/bin/python3

import ply.lex as lex
import ply.yacc as yacc
import sys

P = 1234577
onp = ''
err = False

states = (
    ('comment', 'exclusive'),
)

tokens = (
    'NUM', 'PLUS', 'MINUS', 'TIMES', 'DIVIDE', 'POWER', 'NPOWER', 'LPAR', 'RPAR', 'NL'
)

t_NPOWER   = r'\^[ ]?-'
t_PLUS     = r'\+'
t_MINUS    = r'-'
t_TIMES    = r'\*'
t_DIVIDE   = r'/'
t_LPAR     = r'\('
t_RPAR     = r'\)'
t_POWER    = r'\^'

def t_comment(t):
    r'\#'
    t.lexer.begin('comment')

def t_comment_CONTENT(t):
    r'.*\\\n'
    pass

def t_comment_END(t):
    r'.*\n'
    t.lexer.begin('INITIAL')

def t_linecont(t):
    r'\\\n'
    pass

def t_NUM(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_NL(t):
    r'\n+'
    t.lexer.lineno += len(t.value)
    return t

t_ignore = ' \t'
t_comment_ignore = ' \t'

def t_error(t):
    print("Nielegalny znak '%s'" % t.value[0])
    t.lexer.skip(1)

def t_comment_error(t):
    print("Nielegalny znak '%s'" % t.value[0])
    t.lexer.skip(1)

lexer = lex.lex()

def neg(a):
    return P-a

def add(a, b):
    return (a%P + b%P)%P

def sub(a, b):
    return add(a, neg(b))

def mul(a, b):
    return ((a%P)*(b%P))%P

def mult_inv(a, b):
    if a == 0:
        return b, 0, 1
    g, h1, h2 = mult_inv(b%a, a)
    x = h2 - (b//a)*h1
    y = h1
    return g, x, y

def divide(a, b):
    _, x, _ = mult_inv(b, P)
    if x < 0:
        x += P
    return mul(a, x)

def power(a, b):
    r = 1
    a = a%P
    while b > 0:
        if b%2 == 1:
            r = (r*a)%P
        b //= 2
        a = (a*a)%P
    return r

precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIVIDE'),
    ('nonassoc', 'POWER'),
    ('nonassoc', 'NPOWER'),
    ('right', 'NEG')
)

def p_input(p):
    '''input : empty
             | input line'''
    pass

def p_line_nl(p):
    'line : NL'
    pass

def p_line_err(p):
    'line : error NL' 
    global onp, err
    onp = ''
    err = False

def p_expr_line(p):
    'line : expr NL'
    global onp, err
    if not err:
        print(onp)
        print('Wynik: ', p[1])
    else:
        err = False
    onp = ''

def p_expr_neg(p):
    'expr : MINUS expr %prec NEG'
    global onp
    p[0] = neg(p[2])
    onp = onp[:len(onp)-len(str(p[2]))-1]
    onp += str(p[0]) + ' '

def p_expr_nexp(p):
    'expr : expr NPOWER expr'
    global onp
    p[0] = power(p[1], P-1-p[3])
    onp = onp[:len(onp)-len(str(p[3]%P))-1]
    onp += str(P-1-p[3]) + ' '
    onp += '^ '

def p_expr_num(p):
    'expr : NUM'
    global onp
    p[0] = p[1]%P
    onp += str(p[0]) + ' '

def p_binary_operators(p):
    '''expr : expr PLUS expr
            | expr MINUS expr
            | expr TIMES expr
            | expr DIVIDE expr
            | expr POWER expr
            | LPAR expr RPAR'''
    global onp, err
    if p[2] == '+':
        p[0] = add(p[1], p[3])
        onp += '+ '
    elif p[2] == '-':
        p[0] = sub(p[1], p[3])
        onp += '- '
    elif p[2] == '*':
        p[0] = mul(p[1], p[3])
        onp += '* '
    elif p[2] == '/':
        if p[3] != 0:
            p[0] = divide(p[1], p[3])
            onp += '/ '
        else:
            p_error(p)
            err = True
    elif p[2] == '^':
        p[0] = power(p[1], p[3])
        onp += '^ '
    elif p[1] == '(' and p[3] == ')':
        p[0] = p[2]

def p_empty(p):
    'empty :'
    pass

def p_error(p):
    print('Błąd!')
    global onp
    onp = ''

parser = yacc.yacc()

if __name__ == '__main__':
    data = ''
    for line in sys.stdin:
        data += line
    parser.parse(data)
