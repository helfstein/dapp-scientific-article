var Teste = artifacts.require("./Teste.sol");

module.exports = function(deployer, network, accounts) {
    // Deploys the OraclizeTest contract and funds it with 0.5 ETH
    // The contract needs a balance > 0 to communicate with Oraclize
    const oarAddress = 0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475;
    deployer.deploy(
        Teste, oarAddress , 
      
      { from: accounts[2], gas: 6721975, value: 500000000000000000 });
      
  };

