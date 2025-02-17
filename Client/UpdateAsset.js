const ClientApplication = require('./client');

let userClient = new ClientApplication();
userClient.submitTxn(
    "organization1admin",   
    "orgchannel",           
    "Asset",                 
    "UpdateAsset",          
    "Asset-100",            
    "user2",                
    "7000"                  
).then(result => {
    console.log(new TextDecoder().decode(result));
    console.log("Asset successfully updated");
}).catch(error => {
    console.error("Failed to update asset:", error);
});
