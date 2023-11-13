1) if you don't use the default port for ldap you have to specify it when do the query -H ldap://localhost:newport, and it should be a port exposed in the docker container.

2) to check if the docker is working well do: 
	sudo docker exec cybersec_openldap_1 ldapsearch -x -H ldap://localhost:expoedport

3)
