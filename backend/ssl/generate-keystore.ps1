# Generate keystore for Spring Boot
$password = "changeme"
$dname = "CN=localhost, OU=Development, O=Company, L=City, S=State, C=US"

keytool -genkeypair -alias backend -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore server.p12 -validity 3650 -storepass $password -keypass $password -dname $dname -ext "SAN=DNS:localhost,IP:127.0.0.1"

Write-Host "Keystore generated: server.p12" -ForegroundColor Green