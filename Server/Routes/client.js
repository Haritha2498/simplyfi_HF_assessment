const { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const fs = require('fs');
const { profile } = require('./profile'); 
const gateway = new Gateway();

class ClientApplication {
    constructor() {
        this.walletPath = path.join(__dirname, 'wallet');
    }

    async submitTxn(org, channelName, chaincodeName, functionName, ...args) {
        try {
            // Ensure org exists in profile
            const orgProfile = profile[org];  
            if (!orgProfile) {
                throw new Error(`Organization profile for "${org}" not found.`);
            }
    
            // Load wallet
            const wallet = await Wallets.newFileSystemWallet(this.walletPath);
    
            // Ensure user identity exists in the wallet
            const userIdentity = await wallet.get(org);
            if (!userIdentity) {
                throw new Error(`Identity for "${org}" not found in wallet`);
            }
            
            // Load connection profile dynamically
            const ccpPath = path.resolve(__dirname, '../../Network/connection-org1.json'); 
            const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));
    
            // Declare and connect to Fabric Gateway
            const gateway = new Gateway();
            await gateway.connect(ccp, {
                wallet,
                identity: org,  // Use dynamic identity
                discovery: { enabled: true, asLocalhost: true }
            });
    
            // Get network and contract
            const network = await gateway.getNetwork(channelName);
            const contract = network.getContract(chaincodeName);
    
            // Submit transaction
            const result = await contract.submitTransaction(functionName, ...args);
            console.log(`Transaction ${functionName} with args ${args} has been submitted.`);
            
            await gateway.disconnect();
            return result;
        } catch (error) {
            console.error(`Failed to submit transaction: ${error.message}`);
            process.exit(1);
        }
    }
    
}

module.exports = ClientApplication;
