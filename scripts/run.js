const hre = require('hardhat')

async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners()
  const contractFactory = await hre.ethers.getContractFactory('Messages')
  const contract = await contractFactory.deploy()

  await contract.deployed()

  console.log('Contract deployed to:', contract.address)
  console.log('Contract deployed by:', owner.address)

  console.log()

  let waveTxn

  waveTxn = await contract.connect(randomPerson).create('Message 1.')
  await waveTxn.wait()

  waveTxn = await contract.reply(0, 'Reply 1.')
  await waveTxn.wait()

  waveTxn = await contract.connect(randomPerson).reply(0, 'Reply 2.')
  await waveTxn.wait()

  const messages = await contract.all()
  console.log()
  console.log(messages)
  console.log()
  console.log()
  console.log(messages[0])
  console.log(messages[0].timestamp.toNumber())
}

async function runMain() {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()
