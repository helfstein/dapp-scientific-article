var ArticleContract = artifacts.require("./ArticleContract.sol");

module.exports = function(deployer, network, accounts) {
    // Deploys the OraclizeTest contract and funds it with 0.5 ETH
    // The contract needs a balance > 0 to communicate with Oraclize
    const oarAddress = 0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475;
    const name = "Articles";
    const symbol = "ART";
    deployer.deploy(ArticleContract, oarAddress , name, symbol,{ 
        from: accounts[1], 
        gas: 6721975, 
        value: 5000000000000000000 
    });
      
};

