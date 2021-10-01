const { deployProxy, upgradeProxy } = require('@openzeppelin/truffle-upgrades')

const VolcanoTokenUpgradeable = artifacts.require('VolcanoTokenUpgradeable'); 
const VolcanoTokenUpgradeableV2 = artifacts.require('VolcanoTokenUpgradeableV2');

describe('upgrades', () => { 
    it('works', async () => {
        const volcano = await deployProxy(VolcanoTokenUpgradeable, [], { kind: 'uups' });
        const volcanoV2 = await upgradeProxy(volcano.address, VolcanoTokenUpgradeableV2);
        const version = await volcanoV2.VERSION.call();
        assert.equal(version.toNumber(), 2);
    });
});