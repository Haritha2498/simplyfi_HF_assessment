const express=require('express')
const router = express.Router();

const ClientApplication= require('./client.js')


const userClient = new ClientApplication();


router.post('/assets', async (req, res) => {
    try {
        const { assetId, owner, value } = req.body;
        const result = await userClient.submitTxn(
            "organization1admin",
            "orgchannel",
            "Asset",
            "CreateAsset",
            assetId,
            owner,
            value
        );
        res.json({ message: "Asset created successfully", result: new TextDecoder().decode(result) });
    } catch (error) {
        res.status(500).json({ error: "Failed to create asset", details: error.message });
    }
});



router.get('/allassets', async (req, res) => {
    try {
        const result = await userClient.submitTxn(
            "organization1auditor",
            "orgchannel",
            "Asset",
            "GetAllAssets"
        );
        res.json({ assets: JSON.parse(new TextDecoder().decode(result)) });
    } catch (error) {
        res.status(500).json({ error: "Failed to retrieve assets", details: error.message });
    }
});

router.get('/assets/:id', async (req, res) => {
    try {
        const assetId = req.params.id;
        const result = await userClient.submitTxn(
            "organization1auditor",
            "orgchannel",
            "Asset",
            "ReadAsset",
            assetId
        );
        res.json({ asset: JSON.parse(new TextDecoder().decode(result)) });
    } catch (error) {
        res.status(500).json({ error: `Failed to read asset ${req.params.id}`, details: error.message });
    }
});

router.put('/updateasset', async (req, res) => {
    try {
        const { assetId, newOwner, newValue } = req.body;
        const result = await userClient.submitTxn(
            "organization1admin",
            "orgchannel",
            "Asset",
            "UpdateAsset",
            assetId,
            newOwner,
            newValue
        );
        res.json({ message: "Asset updated successfully", result: new TextDecoder().decode(result) });
    } catch (error) {
        res.status(500).json({ error: `Failed to update asset ${req.body.assetId}`, details: error.message });
    }
});


router.delete('/assets/:id', async (req, res) => {
    try {
        const assetId = req.params.id;
        const result = await userClient.submitTxn(
            "organization1admin",
            "orgchannel",
            "Asset",
            "DeleteAsset",
            assetId
        );
        res.json({ message: `Asset ${assetId} deleted successfully`, result: new TextDecoder().decode(result) });
    } catch (error) {
        res.status(500).json({ error: `Failed to delete asset ${req.params.id}`, details: error.message });
    }
});

module.exports = router;