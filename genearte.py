import llama_cpp

# Initialize Llama object
llm = llama_cpp.Llama(model_path="./model/llama-2.gguf", n_ctx=512, n_batch=128)

# Generate random data
#random_data = llm("Q: Generate random data for an ldap server. make sure to print a .schema file and the correspondant .ldif", max_tokens=32, stop=["Q:", "\n"], echo=True)
prompt = "Make 10 examples of .schema and the correspondant .ldif file for an ldap server"

output = llm(prompt, max_tokens=-1,temperature=0.5,top_p=0.9)
# Print generated data
print(output['choices'][0]['text'])

# Write to file
with open("response.txt", "a") as f:
  f.write(output['choices'][0]['text'])
