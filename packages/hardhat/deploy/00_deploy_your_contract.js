// deploy/00_deploy_your_contract.js

//const { ethers } = require("hardhat");
let { networkConfig } = require('../helper-hardhat-config')

module.exports = async ({ getNamedAccounts,
  deployments,
  getChainId }) => {

  // await deploy("SVGNFT", {
  //   // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
  //   from: deployer,
  //   //args: [ "Hello", ethers.utils.parseEther("1.5") ],
  //   log: true,
  // });

  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = await getChainId()

  log("----------------------------------------------------")
  const SVGNFT = await deploy('SVGNFT', {
    from: deployer,
    log: true
  })
  log(`You have deployed an NFT contract to ${SVGNFT.address}`)
  const svgNFTContract = await ethers.getContractFactory("SVGNFT")
  const accounts = await hre.ethers.getSigners()
  const signer = accounts[0]
  const svgNFT = new ethers.Contract(SVGNFT.address, svgNFTContract.interface, signer)
  const networkName = networkConfig[chainId]['name']

  log(`Verify with:\n npx hardhat verify --network ${networkName} ${svgNFT.address}`)
  log("Let's create an NFT now!")

  log(`We will use  as our SVG, and this will turn into a tokenURI. `)
  tx = await svgNFT.create(1, 9);
  await tx.wait(1)
  tx2 = await svgNFT.create(2, 55);
  await tx2.wait(1)
  tx3 = await svgNFT.updateMonster(0)
  await tx3.wait(1)
  log(`You've made your first NFT!`)
  log(`You can view the tokenURI here ${await svgNFT.tokenURI(0)}`)



  /*
    // Getting a previously deployed contract
    const YourContract = await ethers.getContract("YourContract", deployer);
    await YourContract.setPurpose("Hello");

    To take ownership of yourContract using the ownable library uncomment next line and add the
    address you want to be the owner.
    // yourContract.transferOwnership(YOUR_ADDRESS_HERE);

    //const yourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A") //<-- if you want to instantiate a version of a contract at a specific address!
  */

  /*
  //If you want to send value to an address from the deployer
  const deployerWallet = ethers.provider.getSigner()
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */

  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */

  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */
};
module.exports.tags = ["all", "svg"];

/*
Tenderly verification
let verification = await tenderly.verify({
  name: contractName,
  address: contractAddress,
  network: targetNetwork,
});
*/
