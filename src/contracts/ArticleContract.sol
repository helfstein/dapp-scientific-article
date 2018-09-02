pragma solidity ^0.4.24;

import "../installed_contracts/oraclize-api/contracts/usingOraclize.sol";
import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./StringUtils.sol";

contract ArticleContract is usingOraclize, Ownable, ERC721Token {
//==========================================================================

    using SafeMath for uint256;
    using StringUtils for *;

    //It will represents a single scientific article
    struct Article {
        string title; //represents a title
        string author; //author name
        string issn; //8 digit number for identify and validate the article ISSN (International Standard Serial Number)
        string category;
        string description; //a brief description for the article
        string filePath; //the directory where the article will be storage
        address articleAddress;
    }

    mapping(uint => mapping(uint => Article)) data;

    event ArticleResponse(string result);

    //----------------------------------------------------------------------------
    constructor(address _oarAddress, string _name, string _symbol) ERC721Token(_name, _symbol) public payable {

        OAR = OraclizeAddrResolverI(_oarAddress);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);

    }
    //----------------------------------------------------------------------------
    function __callback(bytes32 id, string result, bytes proof) public {
        require(msg.sender == oraclize_cbAddress(), "This address is not a valid coinbase");

        emit ArticleResponse(result);
    }
    //----------------------------------------------------------------------------
    // Fallback function
    function() public{
        revert("reverted");
    }
    //----------------------------------------------------------------------------
    function publishArticle(string issn, string author) public payable {
        // oraclize_query("URL", datasource, _article.issn);
        var a = "{'issn': '";
        var b = "', 'author': '";
        var c = "'}";
        var payload = strConcat(a, issn, b, author, c);
        oraclize_query("URL", "json(https://localhost:5001/api/article)", payload);
    }
//==========================================================================
}