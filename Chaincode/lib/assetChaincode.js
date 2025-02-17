'use strict';

const { Contract } = require('fabric-contract-api');

class AssetTransfer extends Contract {
    
    async CreateAsset(ctx, id, owner, value) {
        const role = await this.getClientRole(ctx);
        if (role !== 'admin') {
            throw new Error('Access denied: Only admins can create assets');
        }

        const asset = {
            ID: id,
            Owner: owner,
            Value: parseInt(value),
        };

        await ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
        return `Asset ${id} created successfully`;
    }

    //  Read an Asset - Auditors can read all assets, Users can only read their own
    async ReadAsset(ctx, id) {
        const assetBytes = await ctx.stub.getState(id);
        if (!assetBytes || assetBytes.length === 0) {
            throw new Error(`Asset ${id} not found`);
        }

        const asset = JSON.parse(assetBytes.toString());
        const role = await this.getClientRole(ctx);
        const clientEnrollmentID = this.getClientEnrollmentID(ctx);

        if (role === 'auditor' || asset.Owner === clientEnrollmentID) {
            return asset;
        } else {
            throw new Error('Access denied: You can only view your own assets');
        }
    }


    // Get All Assets - Only Auditors can view all assets
    async GetAllAssets(ctx) {
        const role = await this.getClientRole(ctx);
        if (role !== 'auditor') {
            throw new Error('Access denied: Only auditors can view all assets');
        }

        const iterator = await ctx.stub.getStateByRange('', '');
        const assets = [];
        
        while (true) {
            const result = await iterator.next();
            if (result.value && result.value.value.toString()) {
                const asset = JSON.parse(result.value.value.toString());
                assets.push(asset);
            }
            if (result.done) break;
        }

        return JSON.stringify(assets);
    }

    // Update an Asset - Only Admins can update assets
    async UpdateAsset(ctx, id, newOwner, newValue) {
        const role = await this.getClientRole(ctx);
        if (role !== 'admin') {
            throw new Error('Access denied: Only admins can update assets');
        }

        const assetBytes = await ctx.stub.getState(id);
        if (!assetBytes || assetBytes.length === 0) {
            throw new Error(`Asset ${id} not found`);
        }

        const asset = JSON.parse(assetBytes.toString());
        asset.Owner = newOwner;
        asset.Value = parseInt(newValue);

        await ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
        return `Asset ${id} updated successfully`;
    }

    // Delete an Asset - Only Admins can delete assets
    async DeleteAsset(ctx, id) {
        const role = await this.getClientRole(ctx);
        if (role !== 'admin') {
            throw new Error('Access denied: Only admins can delete assets');
        }

        const assetBytes = await ctx.stub.getState(id);
        if (!assetBytes || assetBytes.length === 0) {
            throw new Error(`Asset ${id} not found`);
        }

        await ctx.stub.deleteState(id);
        return `Asset ${id} deleted successfully`;
    }

    // Get Client Role from Identity
    async getClientRole(ctx) {
        const role = ctx.clientIdentity.getAttributeValue('role');
        if (!role) {
            console.warn('No role found in identity attributes. Assigning "user" by default.');
            return 'user';
        }
        return role;
    }

    // Get Client ID
    getClientEnrollmentID(ctx) {
        return ctx.clientIdentity.getID().split("::")[1];
    }
}

module.exports = AssetTransfer;
