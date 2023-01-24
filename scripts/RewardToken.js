const hre = require("hardhat");
async function main() {
  
  const RewardToken = await hre.ethers.getContractFactory("RewardToken");
  const rewardToken = await RewardToken.deploy();

  await rewardToken.deployed();

  console.log(
    `Contract RewardToken is deployed to ${rewardToken.address}`
  );
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
//0x262cd5507A0738f43047C1607f9998A6d3792284
