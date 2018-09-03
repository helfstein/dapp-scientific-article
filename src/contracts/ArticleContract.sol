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
        //var url = '[json(https://articledapp.azurewebsites.net/api/article).result, {issn : "';
        //var a = '';
        //var b = '", author: "';
        //var c = '"}]';
        //var payload = strConcat(url, issn, b, author, c);
        //var url = ;
        //oraclize_query("URL", payload);
        oraclize_query("URL", "json(https://articledapp.azurewebsites.net/api/article).data", ' {"issn" : "111", "author": "eu"}');
        //oraclize_query("URL", "json(https://articledapp.azurewebsites.net/api/article).accepted");
        //oraclize_query("URL", "json(https://shapeshift.io/sendamount).success.deposit",
         //   '{"pair":"eth_btc","amount":"1","withdrawal":"1AAcCo21EUc1jbocjssSQDzLna9Vem2UN5"}')
        //oraclize_query("URL", "json(https://api.coinbase.com/v2/prices/ETH-USD/spot)");
    }
//==========================================================================
}