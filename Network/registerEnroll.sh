#!/bin/bash

function createOrg1() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/organization1.sample.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/organization1.sample.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-organization1 --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-organization1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-organization1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-organization1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-organization1.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/config.yaml"

  # Copy Organization1's CA Certs
  mkdir -p "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/organization1.sample.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/organization1.sample.com/tlsca/tlsca.organization1.sample.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/organization1.sample.com/ca"
  cp "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/organization1.sample.com/ca/ca.organization1.sample.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-organization1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-organization1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

 echo "Registering a Regular User in Org1"

fabric-ca-client register --caname ca-organization1 --id.name organization1user --id.secret organization1userpw  --id.type client  --id.attrs "role=user:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"

echo "Registering the Org1 Auditor"
fabric-ca-client register --caname ca-organization1 --id.name organization1auditor --id.secret organization1auditorpw --id.type client --id.attrs "role=auditor:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
{ set +x; } 2>/dev/null

 echo "Registering the Org1 Admin"
fabric-ca-client register --caname ca-organization1 --id.name organization1admin --id.secret organization1adminpw --id.type admin --id.attrs "role=admin:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"


{ set +x; } 2>/dev/null


  # Enroll peer0
  echo "Generating the peer0 MSP"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-organization1 -M "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/msp/config.yaml"

  # Generate TLS certificates for peer0
  echo "Generating the peer0 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 \
    --caname ca-organization1 \
    -M "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.organization1.sample.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/server.key"

  # Enroll peer1
  echo "Generating the peer1 MSP"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-organization1 -M "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/msp/config.yaml"

  # Generate TLS certificates for peer1
  echo "Generating the peer1 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-organization1 -M "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls" --enrollment.profile tls --csr.hosts peer1.organization1.sample.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/peers/peer1.organization1.sample.com/tls/server.key"

  # Enroll user1
      echo "Enrolling a Regular User in Org1"
   fabric-ca-client enroll -u https://organization1user:organization1userpw@localhost:7054  --caname ca-organization1 --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/organization1.sample.com/users/User@organization1.sample.com/msp"  --enrollment.attrs "role"

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/users/User@organization1.sample.com/msp/"
  # Enroll auditor
     echo "Enrolling the Org1 Auditor"
      set -x
fabric-ca-client enroll -u https://organization1auditor:organization1auditorpw@localhost:7054 --caname ca-organization1 --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem" --mspdir "${PWD}/organizations/peerOrganizations/organization1.sample.com/users/Auditor@organization1.sample.com/msp" --enrollment.attrs "role"
   { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/users/Auditor@organization1.sample.com/msp/"
  
  # Enroll org admin
    echo "Enrolling the Org1 Admin"
      set -x
fabric-ca-client enroll -u https://organization1admin:organization1adminpw@localhost:7054 --caname ca-organization1 --tls.certfiles "${PWD}/organizations/fabric-ca/organization1/ca-cert.pem" --mspdir "${PWD}/organizations/peerOrganizations/organization1.sample.com/users/Admin@organization1.sample.com/msp" --enrollment.attrs "role"     
 { set +x; } 2>/dev/null

 cp "${PWD}/organizations/peerOrganizations/organization1.sample.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/organization1.sample.com/users/Admin@organization1.sample.com/msp/"

}

function createOrg2() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/organization2.sample.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/organization2.sample.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-organization2 --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-organization2.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/config.yaml"

  # Copy Organization2's CA Certs
  mkdir -p "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/organization2.sample.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/organization2.sample.com/tlsca/tlsca.organization2.sample.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/organization2.sample.com/ca"
  cp "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/organization2.sample.com/ca/ca.organization2.sample.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-organization2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-organization2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

    echo "Registering a Regular User in Org2"
        set -x
        fabric-ca-client register --caname ca-organization2  --id.name organization2user --id.secret organization2userpw --id.type client   --id.attrs "role=user:ecert"  --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
        { set +x; } 2>/dev/null  

    echo "Registering the Org2 Auditor"
    set -x 
    fabric-ca-client register --caname ca-organization2 --id.name organization2auditor  --id.secret organization2auditorpw  --id.type client --id.attrs "role=auditor:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering the Org2 Admin"
      set -x 
      fabric-ca-client register --caname ca-organization2  --id.name organization2admin --id.secret organization2adminpw  --id.type admin  --id.attrs "role=admin:ecert"  --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
    { set +x; } 2>/dev/null




  # Enroll peer0
  echo "Generating the peer0 MSP"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-organization2 -M "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/msp/config.yaml"

  # Generate TLS certificates for peer0
  echo "Generating the peer0 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 \
    --caname ca-organization2 \
    -M "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.organization2.sample.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer0.organization2.sample.com/tls/server.key"

  # Enroll peer1
  echo "Generating the peer1 MSP"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-organization2 -M "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/msp/config.yaml"

  # Generate TLS certificates for peer1
  echo "Generating the peer1 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-organization2 -M "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls" --enrollment.profile tls --csr.hosts peer1.organization2.sample.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/peers/peer1.organization2.sample.com/tls/server.key"

  # Enroll user1
      echo "Enrolling a Regular User in Org2"
    set -x
fabric-ca-client enroll -u https://organization2user:organization2userpw@localhost:8054  --caname ca-organization2  --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/organization2.sample.com/users/User@organization2.sample.com/msp"

   { set +x; } 2>/dev/null

     cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/users/User@organization2.sample.com/msp/"

  # Enroll auditor
     echo "Enrolling the Org2 Auditor"
      set -x
fabric-ca-client enroll -u https://organization2auditor:organization2auditorpw@localhost:8054  --caname ca-organization2  --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/organization2.sample.com/users/Auditor@organization2.sample.com/msp" 
  
   cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/users/Auditor@organization2.sample.com/msp/"
 
  # Enroll org admin
    echo "Enrolling the Org2 Admin"
      set -x
fabric-ca-client enroll -u https://organization2admin:organization2adminpw@localhost:8054  --caname ca-organization2  --tls.certfiles "${PWD}/organizations/fabric-ca/organization2/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/organization2.sample.com/users/Admin@organization2.sample.com/msp" 

  cp "${PWD}/organizations/peerOrganizations/organization2.sample.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/organization2.sample.com/users/Admin@organization2.sample.com/msp/"
}






function createOrderer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/sample.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/sample.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/sample.com/msp/config.yaml"


  # Copy orderer org's CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/sample.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/sample.com/msp/tlscacerts/tlsca.sample.com-cert.pem"

  # Copy orderer org's CA cert to orderer org's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/ordererOrganizations/sample.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/sample.com/tlsca/tlsca.sample.com-cert.pem"

  echo "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the orderer msp"
  set -x
fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/sample.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/msp/config.yaml"

  echo "Generating the orderer-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls" --enrollment.profile tls --csr.hosts orderer.sample.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
  cp "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/server.key"

  # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/sample.com/orderers/orderer.sample.com/msp/tlscacerts/tlsca.sample.com-cert.pem"

  echo "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/sample.com/users/Admin@sample.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/sample.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/sample.com/users/Admin@sample.com/msp/config.yaml"
}

createOrg1
createOrg2

createOrderer
