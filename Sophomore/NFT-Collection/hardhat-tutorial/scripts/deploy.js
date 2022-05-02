const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env"});
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {

    const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
    //URL from where we can extract the metadata for a cryptodev
    const metadadataURL = METADATA_URL;


    //First step to deploy the SmartContractFactory
    const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");

    // Next deploy the contract
    const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
        metadadataURL,
        whitelistContract
        );
    
    console.log("Deployed contract is: ", deployedCryptoDevsContract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })
