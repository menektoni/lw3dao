const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { CRYPTODEVS_NFT_ADDRESS } = require("../constants")

async function main() {
    // First step should be to deploy the contract factory
    const CryptoDevsTokenContract = await ethers.getContractFactory("CryptoDevsToken");

    const deployedCryptoDevsTokenContract = await CryptoDevsTokenContract.deploy(CRYPTODEVS_NFT_ADDRESS);

    console.log("CryptoDevs Token address is: ", deployedCryptoDevsTokenContract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })