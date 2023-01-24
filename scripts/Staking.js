const hre = require("hardhat");
async function main() {
  
  const Staking = await hre.ethers.getContractFactory("Staking");
  const staking = await Staking.deploy("0x61E4BEf6D71363dfdF8baC58798789e0742F4e49","0x262cd5507A0738f43047C1607f9998A6d3792284");

  await staking.deployed();

  console.log(
    `Contract Staking is deployed to ${staking.address}`
  );
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
//0xAE76d521Cb39A59788b2a0BE1eB2Fc79057FA47C
