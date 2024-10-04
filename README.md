## Locally signed TSL certificates
To use TSL on a local network with self-signed there are several options:
1. Use ACME and a service like _Let's Encrypte_ to automatically manage certificates. This required an internet connection between the server and the certificate provider.
2. Create a self-signed certificate (e.g. with `openssl`). This cert has be manually whitelisted for any clients accessing the server.
3. Slight improvement on 2., create a new certificate authority (CA) (basically just a key pair with some extra meta-data in the form of a `.crt` certificate file containing the public key and meta-data, and a `.key` file containing the private key). The new CA is used to sign a certificate for the server. The CA should be added as a trusted CA for clients of the server.

### Generating a new CA and server certificate
See and edit the parameters in the `Makefile`, and then `make` to produce:
- CA certificate
- CA private key
- server certificate
- server private key

**Keep the CA private key safe because it enables new certs to be produced that are considered trusted for any devices on which the CA has been added as a trusted CA!**

The steps in the `Makefile` were informed by this [blog post](https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/).
