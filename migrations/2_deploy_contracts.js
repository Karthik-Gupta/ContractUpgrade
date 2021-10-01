const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const VolcanoToken = artifacts.require("VolcanoToken");
const VolcanoTokenUpgradeable = artifacts.require("VolcanoTokenUpgradeable");

module.exports = async function (deployer) {
  const volcanoInstance = await deployer.deploy(VolcanoToken);
  const volcanoUpgradeInstance = await deployProxy(VolcanoTokenUpgradeable, [], {kind: 'uups'});
  console.log('Deployed VolcanoTokenUpgradeable ', volcanoUpgradeInstance.address);
};
