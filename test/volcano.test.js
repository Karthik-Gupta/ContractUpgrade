 const VolcanoToken = artifacts.require("VolcanoToken");
 
 contract('VolcanoToken', accounts => {
    const ownerAddr = accounts[4]
     before(async () => {
         /* before tests */
         volcanoTokenInstance = await VolcanoToken.deployed();
     });
     
     it("Check the mint function!", async() => {
         const bal = await volcanoTokenInstance.balanceOf(ownerAddr);
         await volcanoTokenInstance.mintToken({
            from: ownerAddr});
        const newBal = await volcanoTokenInstance.balanceOf(ownerAddr);
         assert.equal(bal.toNumber() + 1, newBal.toNumber());
     });

     it("Check the version of the contract!", async() => {
        const version = await volcanoTokenInstance.VERSION.call();
        assert.equal(version.toNumber(), 1);
     });

     it("Check the token symbol!", async() => {
        const symbol = await volcanoTokenInstance.symbol();
        assert.equal(symbol, "VTK");
     });
 });
 