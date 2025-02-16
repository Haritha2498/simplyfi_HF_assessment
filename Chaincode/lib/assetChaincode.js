'use strict';

const { Contract } = require('fabric-contract-api');

class AssetTransfer extends Contract {

    
    async CreateAsset(ctx, assetID, owner, value) {
        const role = await this.GetClientRole(ctx);
        if (role !== 'Admin') {
            throw new Error('Only Admins can create assets');
        }
        const exists = await this.AssetExists(ctx, assetID);
        if (exists) {
            throw new Error(`Asset ${assetID} already exists`);
        }
        const asset = { assetID, owner, value: parseInt(value) };
        await ctx.stub.putState(assetID, Buffer.from(JSON.stringify(asset)));
        return JSON.stringify(asset);
    }

    async ReadAsset(ctx, assetID) {
        const assetJSON = await ctx.stub.getState(assetID);
        if (!assetJSON || assetJSON.length === 0) {
            throw new Error(`Asset ${assetID} does not exist`);
        }
        const asset = JSON.parse(assetJSON.toString());
        const role = await this.GetClientRole(ctx);
        const clientID = await this.GetClientID(ctx);

        if (role === 'Auditor' || asset.owner === clientID) {
            return JSON.stringify(asset);
        } else {
            throw new Error('Access Denied: You can only view your own assets');
        }
    }

    async UpdateAsset(ctx, assetID, newValue) {
        const assetString = await this.ReadAsset(ctx, assetID);
        const asset = JSON.parse(assetString);
        asset.value = parseInt(newValue);
        await ctx.stub.putState(assetID, Buffer.from(JSON.stringify(asset)));
        return JSON.stringify(asset);
    }

    async DeleteAsset(ctx, assetID) {
        const exists = await this.AssetExists(ctx, assetID);
        if (!exists) {
            throw new Error(`Asset ${assetID} does not exist`);
        }
        await ctx.stub.deleteState(assetID);
        return `Asset ${assetID} deleted`;
    }

    async GetAllAssets(ctx) {
        const role = await this.GetClientRole(ctx);
        if (role !== 'Auditor') {
            throw new Error('Only Auditors can view all assets');
        }
        const iterator = await ctx.stub.getStateByRange('', '');
        const assets = [];
        let result = await iterator.next();
        while (!result.done) {
            const asset = JSON.parse(result.value.value.toString('utf8'));
            assets.push(asset);
            result = await iterator.next();
        }
        return JSON.stringify(assets);
    }

    async AssetExists(ctx, assetID) {
        const assetJSON = await ctx.stub.getState(assetID);
        return assetJSON && assetJSON.length > 0;
    }

    async GetClientRole(ctx) {
        const identity = ctx.clientIdentity;
        return identity.getAttributeValue('role');
    }

    async GetClientID(ctx) {
        return ctx.clientIdentity.getID();
    }
}

module.exports = AssetTransfer;
