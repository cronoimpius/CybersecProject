#! /usr/bin/env python3
# vim:fenc=utf-8
#
# Copyright © 2023 t14 <t14@t14>
#
# Distributed under terms of the MIT license.

"""
Use ollama in a scipt
"""

from langchain.llms import Ollama
olama= Ollama(model="llama2")
out=olama("generate 10 entry for ldap server using ldif syntax")
with open("./data/response.txt", "a") as f:
  f.write(out)

