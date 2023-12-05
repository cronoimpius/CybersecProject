#! /usr/bin/env python3.11
# vim:fenc=utf-8
#
# Copyright © 2023 t14 <t14@t14>
#
# Distributed under terms of the MIT license.

"""
Use ollama in a scipt
"""
import json,os,sys
from langchain.llms import Ollama

ltemp = {
 "dn": "cn=John Doe,ou=people,dc=example,dc=com",
 "objectClass": ["top", "person", "organizationalPerson", "inetOrgPerson"],
 "cn": "John Doe",
 "sn": "Doe",
 "givenName":"Jhon",
 "mail": "jdoe@example.com",
 "userPassword": "{SSHA}y6fKt9JVyP1SX2+5UkGX8X+Yq4"
}
"""stemp = {

}
"""

olama= Ollama(
    model="llama2",
)
out=olama.predict(f"generate 5 example of an employee of Example, Inc. \nUse the following template: {json.dumps(ltemp)}.")
#with open("./data/response.txt", "a") as f:
#  f.write(out)

print(out)
lines=out.splitlines()
data = lines[2:-1]
data = [line.lstrip('0123456789. ') for line in data]

with open("out.txt", "a") as f:
    for d in data:
        f.write(d)
        f.write("\n")

with open("out.txt", "r") as f:
    text=f.read()
    lines=text.split('\n')

os.remove("out.txt")
print(lines)
with open("/init/data/23_example.ldif", "a") as f:
    for line in lines:
        if len(line)>1:
            dic = json.loads(line)
            print(dic)
            for key, value in dic.items():
                if isinstance(value, list):
                    for item in value:
                        #print(f'{key}:{item}')
                        f.write(f'{key}: {item}\n')
                else:
                    f.write(f'{key}: {value}\n')
            f.write('\n')
