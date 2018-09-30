var CryptoArticles = artifacts.require("./CryptoArticles.sol");

module.exports = function(deployer, network, accounts) {
    // Deploys the OraclizeTest contract and funds it with 0.5 ETH
    // The contract needs a balance > 0 to communicate with Oraclize
    //const oarAddress = 0x617d1A1a3c8e8589bC5f5c1875a93909bFd92363;
    const name = "Articles"; 
    const symbol = "ART";
    // deployer.deploy(CryptoArticles, oarAddress , name, symbol,{ 
    //     from: accounts[1], 
    //     gas: 6721975, 
    //     value: 5000000000000000000 
    // });
    deployer.deploy(CryptoArticles, name, symbol,{ 
        from: accounts[0], 
        gas: 6721975, 
        value: 500000000000000000000
    });
};

