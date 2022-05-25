const { ethers, upgrades, network } = require("hardhat");

const {
    Attach,
    Accounts
} = require('./deployed')

async function main() {
    // console.log(network)
    const accounts = await Accounts()
    const usdt = await Attach.USDT
    console.log(
        await usdt.balanceOf(accounts[0].address)
    )
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});