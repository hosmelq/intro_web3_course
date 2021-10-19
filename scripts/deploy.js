const hre = require('hardhat')

async function main() {
  const [deployer] = await hre.ethers.getSigners()
  const accountBalance = await deployer.getBalance()

  console.log('Deploying contracts with account: ', deployer.address)
  console.log('Account balance: ', accountBalance.toString())

  const Token = await hre.ethers.getContractFactory('Messages')
  const portal = await Token.deploy()

  await portal.deployed()

  console.log('address: ', portal.address)
}

async function runMain() {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.error(error)
    process.exit(1)
  }
}

runMain()
