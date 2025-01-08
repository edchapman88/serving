dir = certs
local_dir = physical
vm_dir = virtual
cert_auth_name = some-cert-auth
server_name = serving
server_IP_vm = 169.254.220.0
server_IP_local = 169.254.220.46

define EXT_TEXT_LOCAL
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $(server_name).local
IP.1 = $(server_IP_local)
endef
export EXT_TEXT_LOCAL

define EXT_TEXT_VM
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $(server_name).vm
IP.1 = $(server_IP_vm)
endef
export EXT_TEXT_VM

all : signed_server_cert_local signed_server_cert_vm

signed_server_cert_local : server_cert_local ca_cert server_san.v3.ext output_dir 
	openssl x509 -req -in $(dir)/$(local_dir)/$(server_name).csr -CA $(dir)/$(cert_auth_name).crt -CAkey $(dir)/$(cert_auth_name).key -CAcreateserial -out $(dir)/$(local_dir)/$(server_name).crt -days 730 -sha256 -extfile $(dir)/$(local_dir)/server_san.v3.ext

signed_server_cert_vm : server_cert_vm ca_cert server_san.v3.ext output_dir 
	openssl x509 -req -in $(dir)/$(vm_dir)/$(server_name).csr -CA $(dir)/$(cert_auth_name).crt -CAkey $(dir)/$(cert_auth_name).key -CAcreateserial -out $(dir)/$(vm_dir)/$(server_name).crt -days 730 -sha256 -extfile $(dir)/$(vm_dir)/server_san.v3.ext

output_dir :
	mkdir $(dir)
	mkdir $(dir)/$(local_dir)
	mkdir $(dir)/$(vm_dir)

ca_secret_key : output_dir 
	openssl genrsa -out $(dir)/$(cert_auth_name).key 4096

ca_cert : ca_secret_key output_dir 
	openssl req -x509 -new -nodes -key $(dir)/$(cert_auth_name).key -sha256 -days 1826 -out $(dir)/$(cert_auth_name).crt -subj '/CN=SomeOrg Root CA/C=GB/ST=London/L=London/O=SomeOrg'

server_cert_local : output_dir 
	openssl req -new -nodes -out $(dir)/$(local_dir)/$(server_name).csr -newkey rsa:4096 -keyout $(dir)/$(local_dir)/$(server_name).key -subj '/CN=$(server_name)/C=GB/ST=London/L=London/O=ServingOrg'

server_cert_vm : output_dir 
	openssl req -new -nodes -out $(dir)/$(vm_dir)/$(server_name).csr -newkey rsa:4096 -keyout $(dir)/$(vm_dir)/$(server_name).key -subj '/CN=$(server_name)/C=GB/ST=London/L=London/O=ServingOrg'

server_san.v3.ext : output_dir
	echo "$$EXT_TEXT_LOCAL" > $(dir)/$(local_dir)/$@
	echo "$$EXT_TEXT_VM" > $(dir)/$(vm_dir)/$@

clean :
	rm -r $(dir)

