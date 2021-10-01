const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const VolcanoTokenUpgradeable = artifacts.require('VolcanoTokenUpgradeable'); 
const VolcanoTokenUpgradeableV2 = artifacts.require('VolcanoTokenUpgradeableV2');

module.exports = async function (deployer) {
const existing = await VolcanoTokenUpgradeable.deployed();
const instance = await upgradeProxy(existing.address, VolcanoTokenUpgradeableV2, { kind: 'uups' } );
console.log("Upgraded", instance.address);
};