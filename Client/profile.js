let profile = {
   
    organization1admin: { 
        "cryptoPath": "../Network/organizations/peerOrganizations/organization1.sample.com",
        "keyDirectoryPath": "../Network/organizations/peerOrganizations/organization1.sample.com/users/Admin@organization1.sample.com/msp/keystore/",
        "certPath": "../Network/organizations/peerOrganizations/organization1.sample.com/users/Admin@organization1.sample.com/msp/signcerts/cert.pem",
        "tlsCertPath": "../Network/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/ca.crt",
        "peerEndpoint": "localhost:7051",
        "peerHostAlias": "peer0.organization1.sample.com",
        "mspId": "organization1-sample-com"
    },
    organization1auditor: { 
        "cryptoPath": "../Network/organizations/peerOrganizations/organization1.sample.com",
        "keyDirectoryPath": "../Network/organizations/peerOrganizations/organization1.sample.com/users/Auditor@organization1.sample.com/msp/keystore/",
        "certPath": "../Network/organizations/peerOrganizations/organization1.sample.com/users/Auditor@organization1.sample.com/msp/signcerts/cert.pem",
        "tlsCertPath": "../Network/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/ca.crt",
        "peerEndpoint": "localhost:7051",
        "peerHostAlias": "peer0.organization1.sample.com",
        "mspId": "organization1-sample-com"
    },
    organization1user: { 
        "cryptoPath": "../Network/organizations/peerOrganizations/organization1.sample.com",
        "keyDirectoryPath": "../Network/organizations/peerOrganizations/organization1.sample.com/User/User@organization1.sample.com/msp/keystore/",
        "certPath": "../Network/organizations/peerOrganizations/organization1.sample.com/users/User@organization1.sample.com/msp/signcerts/cert.pem",
        "tlsCertPath": "../Network/organizations/peerOrganizations/organization1.sample.com/peers/peer0.organization1.sample.com/tls/ca.crt",
        "peerEndpoint": "localhost:7051",
        "peerHostAlias": "peer0.organization1.sample.com",
        "mspId": "organization1-sample-com"
    }
};

module.exports = { profile };
