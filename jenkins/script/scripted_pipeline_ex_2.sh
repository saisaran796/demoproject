#!/bin/bash
printf "This is BASH\n"
printf "Please enter some text: "; read ans
export ans

cat << EOF > main.py
#!/usr/bin/python3 -tt
import subprocess

print('............This is Python')
subprocess.call(["echo","............$ans"])
print('............Done with Python')

EOF

chmod 770 pyscript.py

./main.py

printf "This is BASH again\n"
