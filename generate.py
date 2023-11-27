import llama_cpp

# Initialize Llama object
llm = llama_cpp.Llama(
    model_path="./model/llama-2-7b-chat.Q5_K_M.gguf", 
    n_ctx=512
)

# Generate random data
#random_data = llm("Q: Generate random data for an ldap server. make sure to print a .schema file and the correspondant .ldif", max_tokens=32, stop=["Q:", "\n"], echo=True)
prompt = "Generate 10 entries for an ldap server using ldif syntax"

output = llm(prompt,temperature=1,top_p=0.9,max_tokens=-1)
# Print generated data
print(output['choices'][0]['text'])

# Write to file
with open("response.txt", "a") as f:
  f.write(output['choices'][0]['text'])
