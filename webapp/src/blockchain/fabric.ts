/* eslint-disable */
'use strict';

const {
    Gateway,
    Wallets
} = require('fabric-network');
const FabricCAServices = require('fabric-ca-client');
const path = require('path');
const {
    buildCAClient,
    registerAndEnrollUser,
    enrollAdmin
} = require('./utils/CAUtil');
const {
    buildCCPOrg1,
    buildWallet
} = require('./utils/AppUtil');

const channelName = 'default';
const chaincodeName = 'erc20token';
const mspOrg1 = 'Org1MSP';
const walletPath = path.join(__dirname, 'wallet');
const org1UserId = 'User1';

export class Fabric {
    public contract;
    public ccp;
    public caClient;
    public wallet;
    public network;
    public gateway;

    constructor() {
        this.registerAPI();
    }

    async registerAPI() {

        try {
            // build an in memory object with the network configuration (also known as a connection profile)
            this.ccp = buildCCPOrg1();

            // build an instance of the fabric ca services client based on
            // the information in the network configuration
            this.caClient = buildCAClient(FabricCAServices, this.ccp, 'ca.org1.example.com');

            // setup the wallet to hold the credentials of the application user
            this.wallet = await buildWallet(Wallets, walletPath);

            // in a real application this would be done on an administrative flow, and only once
            await enrollAdmin(this.caClient, this.wallet, mspOrg1);

            // in a real application this would be done only when a new user was required to be added
            // and would be part of an administrative flow
            await registerAndEnrollUser(this.caClient, this.wallet, mspOrg1, org1UserId, 'org1');

            // Create a new gateway instance for interacting with the fabric network.
            // In a real application this would be done as the backend server session is setup for
            // a user that has been verified.
            this.gateway = new Gateway();

            try {
                // setup the gateway instance
                // The user will now be able to create connections to the fabric network and be able to
                // submit transactions and query. All transactions submitted by this gateway will be
                // signed by this user using the credentials stored in the wallet.
                let wallet = this.wallet;
                await this.gateway.connect(this.ccp, {
                    appAdmin: "admin",
                    appAdminSecret : "adminpw",
                    wallet,
                    identity: org1UserId,
                    discovery: {
                        enabled: true,
                        asLocalhost: true
                    } // using asLocalhost as this gateway is using a fabric network deployed locally
                });

                // Build a network instance based on the channel where the smart contract is deployed
                this.network = await this.gateway.getNetwork(channelName);

                // Get the contract from the network.
                this.contract = this.network.getContract(chaincodeName);

                return this.contract;
            } catch (err) {
                console.log(err);
            }
        } catch (err) {
            console.log(err);
        }
    }

    public async query(method, ...args): Promise<string> {
        let result = await this.contract.evaluateTransaction(method, ...args);
        return result.toString();
    }

    public async invoke(method, ...args): Promise<any> {    
        const result = await this.contract.submitTransaction(method, ...args);
        return result.toString();
    }
}
