pragma solidity ^0.4.22;

import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";

contract Teste is usingOraclize {

    
    constructor (address _oarAddress) public payable {
        OAR = OraclizeAddrResolverI(_oarAddress);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    }


}