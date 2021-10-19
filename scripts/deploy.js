const hre = require('hardhat')

async function main() {
  const Token = await hre.ethers.getContractFactory('Messages')
  const portal = await Token.deploy({
    value: hre.ethers.utils.parseEther('0.001'),
  })

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
