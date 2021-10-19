const hre = require('hardhat')

async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners()
  const contractFactory = await hre.ethers.getContractFactory('Messages')
  const contract = await contractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  })

  await contract.deployed()

  console.log('Contract deployed to:', contract.address)
  console.log('Contract deployed by:', owner.address)

  console.log()
  let contractBalance = await hre.ethers.provider.getBalance(contract.address)
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  )

  let waveTxn

  waveTxn = await contract.connect(randomPerson).create('Message 1.')
  await waveTxn.wait()

  waveTxn = await contract.connect(randomPerson).create('Message 1.')
  await waveTxn.wait()

  contractBalance = await hre.ethers.provider.getBalance(contract.address)
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  )

  const messages = await contract.all()
  console.log(`messages: `, messages)
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
