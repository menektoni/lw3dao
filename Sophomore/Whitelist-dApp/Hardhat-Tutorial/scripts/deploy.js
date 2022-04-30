const { ethers } = require("hardhat");

async function main() {
    const whitelistContract = await ethers.getContractFactory("Whitelist");

    /* Below we are deploying the contract with 10 being the maximum number of users.
    If the contract doesn't have a constructor how it do know that 10 is the
     value of the variable "maxWhitelistAddresses"? */
    const deployedWhitelistContract = await whitelistContract.deploy(10);

    await deployedWhitelistContract.deployed();

    console.log("Whitelist Address: ", deployedWhitelistContract.address);
}

// Call the main function and catch an error

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
    process.exit(1);
});