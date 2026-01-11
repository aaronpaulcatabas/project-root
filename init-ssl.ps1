# Create directories
New-Item -ItemType Directory -Force -Path "./frontend/ssl"
New-Item -ItemType Directory -Force -Path "./backend/ssl"

Write-Host "Generating SSL certificates..." -ForegroundColor Green

# Generate Root CA
openssl genrsa -out ./frontend/ssl/ca.key 2048
openssl req -x509 -new -nodes -key ./frontend/ssl/ca.key -sha256 -days 365 -out ./frontend/ssl/ca.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=Localhost CA"

# Generate frontend certificate
openssl genrsa -out ./frontend/ssl/localhost.key 2048
openssl req -new -key ./frontend/ssl/localhost.key -out ./frontend/ssl/localhost.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

Create-ConfigFile -Path "./frontend/ssl/localhost.ext" -Content @"
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName=@alt_names

[alt_names]
DNS.1=localhost
DNS.2=frontend
"@

openssl x509 -req -in ./frontend/ssl/localhost.csr -CA ./frontend/ssl/ca.crt -CAkey ./frontend/ssl/ca.key -CAcreateserial -out ./frontend/ssl/localhost.crt -days 365 -sha256 -extfile ./frontend/ssl/localhost.ext

# Generate backend keystore
$backendSslPath = "./backend/ssl"
$keystorePassword = "changeme"

# Create PKCS12 keystore for Spring Boot
openssl pkcs12 -export -name backend -in ./frontend/ssl/localhost.crt -inkey ./frontend/ssl/localhost.key -out "$backendSslPath/backend.p12" -password "pass:$keystorePassword"

Write-Host "SSL certificates generated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Frontend certificates: ./frontend/ssl/" -ForegroundColor Yellow
Write-Host "Backend keystore: ./backend/ssl/backend.p12" -ForegroundColor Yellow
Write-Host ""
Write-Host "Add the CA certificate to your trusted roots:" -ForegroundColor Cyan
Write-Host "1. Open certmgr.msc" -ForegroundColor Cyan
Write-Host "2. Navigate to Trusted Root Certification Authorities -> Certificates" -ForegroundColor Cyan
Write-Host "3. Import ./frontend/ssl/ca.crt" -ForegroundColor Cyan