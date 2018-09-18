# try python ~/Documents/pythonscripts/basics_scratchpad.py

# lists

a=1
b=2

t=['a',a,'b',b]

print(t)

new_t=t

new_t[2]='c'

print(new_t)
print(t)

# both change bc copying pointer, not actual list. To copy actual list
new_t=list(t)
new_t[2]='new_c'

print(new_t)
print(t)

