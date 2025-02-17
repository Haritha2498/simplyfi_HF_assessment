const ClientApplication = require('./client');

let userClient = new ClientApplication();
userClient.submitTxn(
    "organization1auditor",  
    "orgchannel",          
    "Asset",              
    "GetAllAssets"        
).then(result => {
    console.log("Retrieved Assets:");
    console.log(new TextDecoder().decode(result));
}).catch(error => {
    console.error("Failed to retrieve assets:", error);
});
