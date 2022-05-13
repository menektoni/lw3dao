const { ethers } = require("hardhat");
require("dotenv").config( {path: ".env" });
const { CRYPTO_DEV_TOKEN_CONTRACT_ADDRESS } = require("../constants");

async function main() {
    const cryptoDevTokenAddress = CRYPTO_DEV_TOKEN_CONTRACT_ADDRESS;

    const exchangeContract = await ethers.getContractFactory("Exchange");
    const exchangeContractDeployed = await exchangeContract.deploy(cryptoDevTokenAddress);

    await exchangeContractDeployed.deployed();

    console.log("Exchange address is: ", exchangeContractDeployed.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });