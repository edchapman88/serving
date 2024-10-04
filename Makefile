dir = certs
cert_auth_name = some-cert-auth
server_name = serving
server_IP = 169.254.220.46

signed_server_cert : server_cert ca_cert output_dir 
	openssl x509 -req -in $(dir)/$(server_name).csr -CA $(dir)/$(cert_auth_name).crt -CAkey $(dir)/$(cert_auth_name).key -CAcreateserial -out $(dir)/$(server_name).crt -days 730 -sha256

output_dir :
	mkdir $(dir)

ca_secret_key : output_dir 
	openssl genrsa -out $(dir)/$(cert_auth_name).key 4096

ca_cert : ca_secret_key output_dir 
	openssl req -x509 -new -nodes -key $(dir)/$(cert_auth_name).key -sha256 -days 1826 -out $(dir)/$(cert_auth_name).crt -subj '/CN=SomeOrg Root CA/C=GB/ST=London/L=London/O=SomeOrg'

server_cert : output_dir 
	openssl req -new -nodes -out $(dir)/$(server_name).csr -newkey rsa:4096 -keyout $(dir)/$(server_name).key -subj '/CN=$(server_name)/C=GB/ST=London/L=London/O=ServingOrg'

clean :
	rm -r $(dir)
