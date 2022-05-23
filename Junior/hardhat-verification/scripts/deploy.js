const { ethers, run } = require("hardhat");
require("dotenv").config( {path: ".env"} );
require("@nomiclabs/hardhat-etherscan");

async function main () {



    const verifyContract = await ethers.getContractFactory("Verify");

    const verifyContractDeploy = await verifyContract.deploy();

    await verifyContractDeploy.deployed();

    console.log("Verify Contract Address;", verifyContractDeploy.address);

    console.log("Sleeping...");

    await sleep(50000);

    await hre.run("verify:verify", {
        address: verifyContractDeploy.address,
        constructorArguments: [],
    });
}

function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}


main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });