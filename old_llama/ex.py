#! /usr/bin/env python3
# vim:fenc=utf-8
#
# Copyright © 2023 t14 <t14@t14>
#
# Distributed under terms of the MIT license.

"""
script to create data using llama_cpp_python
"""
from langchain.callbacks.manager import CallbackManager
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from langchain.chains import LLMChain
from langchain.llms import LlamaCpp
from langchain.prompts import PromptTemplate

template = """Q: {question} """
prompt = PromptTemplate(template=template, input_variables=["question"])
callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])


llm = LlamaCpp(
#    model_path="./model/llama-2.gguf", 
    model_path="./model/llama-2-7b-chat.Q5_K_M.gguf",
    n_ctx=2048,
    temperature=0.8,
    #max_tokens=-1,
    verbose=True,
    callback_manager=callback_manager,
    grammar_path="./grammar/json.gbnf",
)

prompt = """
Generate a list of 10 different person using ldif format:
"""
result =[]
for i in range(10):
    result.append(llm(prompt))

#for i in range(10):
#    print(i,") - ",result[i],"\n")
#print(result.shape)
