const hre = require("hardhat");
async function main() {
  
  const StakeToken = await hre.ethers.getContractFactory("StakeToken");
  const stakeToken = await StakeToken.deploy();

  await stakeToken.deployed();

  console.log(
    `Contract StakeToken is deployed to ${stakeToken.address}`
  );
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
//0x61E4BEf6D71363dfdF8baC58798789e0742F4e49