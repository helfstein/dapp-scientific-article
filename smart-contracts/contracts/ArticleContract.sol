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
    //Represents the buyer of the Article
    struct Buyer {
        address walletAddress; // (msg.sender)
        uint amount; //total amount (msg.value)
    }

    //It will represents a single scientific article
    struct Article {
        string title; //represents a title
        string author; //author name
        string issn; //8 digit number for identify and validate the article ISSN (International Standard Serial Number)
        string category;
        string description; //a brief description for the article
        string filePath; //the directory where the article will be storage
        uint price;
        bool approved;
        uint numBuyers;
        uint amount;
        mapping (uint => Buyer) buyers; //represents a set of address that can read the article
        mapping (address => uint) addressToBuyer;
    }

    mapping (uint => address) public articleToOwner;
    mapping (bytes32 => uint) public pendingArticlesValidation;

    modifier onlyBuyerOf(uint _articleId) {
        uint _buyerId = articles[_articleId].addressToBuyer[msg.sender];
        require(_buyerId > 0);
        _;
    }

    Article[] private articles;

    event NewArticle(uint articleId, string title, string author, string issn, string category, string description, uint price);
    event ArticleApproved(uint articleId, string title, string author, string issn, string category, string description, uint price);
    event ArticleRejected(uint articleId, string title, string author, string issn, string category, string description, uint price);
    //----------------------------------------------------------------------------
    constructor(address _oarAddress, string _name, string _symbol) ERC721Token(_name, _symbol) public payable {

        OAR = OraclizeAddrResolverI(_oarAddress);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);

    }
    //----------------------------------------------------------------------------
    //buy a new article with a wallet address paying a amount for the owner of the scientific article
    function buyArticle(uint articleID) public payable {
        Article storage article = articles[articleID];
        uint _buyerId = article.numBuyers++;
        article.buyers[_buyerId] = Buyer({walletAddress: msg.sender, amount: msg.value});
        article.addressToBuyer[msg.sender] = _buyerId;
        article.amount += msg.value;
        address _articleOwner = articleToOwner[articleID];        
        _articleOwner.transfer(msg.value);

    }
    //----------------------------------------------------------------------------
    function getArticle(uint articleID) public onlyBuyerOf(articleID) returns (string, string, string, 
        string, string, uint, bool) {
        Article memory a = articles[articleID];
                
        return (a.title, a.author, a.author, a.category, a.description, a.price, a.approved);
    }
    //----------------------------------------------------------------------------
    function getArticleDetails(uint articleID) public onlyBuyerOf(articleID) returns (string, uint, uint){
        Article memory a = articles[articleID];
        return (a.filePath, a.amount, a.numBuyers);
    }
    //----------------------------------------------------------------------------
    function __callback(bytes32 _id, string _result, bytes _proof) public {
        require(msg.sender == oraclize_cbAddress(), "This address is not a valid coinbase");
        //change contract state
        if (keccak256(abi.encodePacked(_result)) == keccak256("true")) {
            //approves article
            Article storage article = articles[pendingArticlesValidation[_id]];
            article.approved = true;
            emit ArticleApproved(pendingArticlesValidation[_id], article.title, article.author, article.issn, article.category, article.description, article.price);
        }
        else{
            //reject article and informs his owner
        }
    }
    //----------------------------------------------------------------------------
    // Fallback function
    function() public{
        revert("reverted");
    }
    //----------------------------------------------------------------------------
    function publishArticle(
        string _title, string _author, string _issn, string _category,   
        string _description, string _filePath, uint _price) public payable {
        
        string memory a = strConcat(" { 'title': '", _title, "', 'issn': '", _issn, "', 'author': '");
        string memory b = strConcat(_author, "', 'category': '", _category, "', 'description': '");
        string memory c = strConcat(_description, "'}");
        string memory payload = strConcat(a, b, c);
        uint id = _createArticle(_title, _author, _issn, _category, _description, _filePath, _price);
        bytes32 queryId = oraclize_query("URL", "json(https://articledapp.azurewebsites.net/api/article).data.accepted", payload);
        
        pendingArticlesValidation[queryId] = id;
            
    }
    //----------------------------------------------------------------------------
    function _createArticle(
        string _title, string _author, string _issn, string _category, 
        string _description, string _filePath, uint _price) internal returns (uint) {

        uint id = articles.push(Article(_title, _author, _issn, _category, _description, _filePath, _price, false, 0, 0)) - 1;
        articleToOwner[id] = msg.sender;     
        return id;       
    }

//==========================================================================
}