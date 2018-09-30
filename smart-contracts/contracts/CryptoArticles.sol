pragma solidity ^0.4.24;

import "../installed_contracts/oraclize-api/contracts/usingOraclize.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./StringUtils.sol";
import "./CryptoArticlesOwnable.sol";
import "./CryptoArticleFactory.sol";

contract CryptoArticles is usingOraclize, ERC721Token, CryptoArticleFactory, CryptoArticlesOwnable {
    //==========================================================================
    using SafeMath for uint256;
    using StringUtils for *;
    
    modifier onlyBuyerOf(uint _articleId) {
        uint _buyerId = articles[_articleId].addressToBuyer[msg.sender];
        require(_buyerId > 0, "Access denied");
        _;
    }

    
    event ArticleApproved(uint articleId, string title, string author, string issn, string category, string description, uint price);
    event ArticleRejected(uint articleId, string title, string author, string issn, string category, string description, uint price);
    event ArticleBuyed(uint articleId, address buyer);
    //event CallbackReceived(string result);

    //----------------------------------------------------------------------------
    // constructor(address _oarAddress, string _name, string _symbol) ERC721Token(_name, _symbol) public payable {

    //     OAR = OraclizeAddrResolverI(_oarAddress);
    //     oraclize_setCustomGasPrice(800000000);
    //     oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);

    // }
    constructor(string _name, string _symbol) ERC721Token(_name, _symbol) public payable {

        //OAR = OraclizeAddrResolverI(_oarAddress);
        //oraclize_setCustomGasPrice(4000000000);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);

    }
    //----------------------------------------------------------------------------
    //buy a new article with a wallet address paying a amount for the owner of the scientific article
    function buyArticle(uint articleID) public payable returns (uint) {
        Article storage article = articles[articleID];
        uint _buyerId = article.numBuyers++;
        article.buyers[_buyerId] = Buyer({walletAddress: msg.sender, amount: msg.value});
        article.addressToBuyer[msg.sender] = _buyerId;
        article.amount += msg.value;
        address _articleOwner = articleToOwner[articleID];        
        _articleOwner.transfer(msg.value);
        //emit ArticleBuyed(articleID, address(msg.sender));
        return (_buyerId);
    }
    //----------------------------------------------------------------------------
    function getArticle(uint articleID) public onlyBuyerOf(articleID) view returns (string, string, string, 
        string, string, uint, bool) {
        Article memory a = articles[articleID];
                
        return (a.title, a.author, a.author, a.category, a.description, a.price, a.approved);
    }
    //----------------------------------------------------------------------------
    function getBuyedArticles() public view returns (uint[]) {
        
        uint[] memory articleIds;
        uint pos = 0;
        for (uint i = 0; i < articles.length; i++) {
            // Article article = ;
            if (articles[i].addressToBuyer[msg.sender] > 0) {
                articleIds[pos] = i;
                pos++;
            }
        }         

        return(articleIds);

    }
    //----------------------------------------------------------------------------
    function getArticleDetails(uint articleID) public onlyBuyerOf(articleID) view returns (string, uint, uint){
        Article memory a = articles[articleID];
        return (a.filePath, a.amount, a.numBuyers);
    }
    //----------------------------------------------------------------------------
    function __callback(bytes32 id, string result, bytes proof) public {
        //emit CallbackReceived(result);
        require(msg.sender == oraclize_cbAddress(), "This address is not a valid coinbase");
        Article storage article = articles[pendingArticlesValidation[id]];
        //change contract state
        if (keccak256(abi.encodePacked(result)) == keccak256("true")) {
            //estava só declarando a variavel aqui            
            //Article storage article = articles[pendingArticlesValidation[id]];
            article.approved = true;
            emit ArticleApproved(pendingArticlesValidation[id], article.title, article.author, article.issn, article.category, article.description, article.price);
        }
        else{
            emit ArticleRejected(pendingArticlesValidation[id], article.title, article.author, article.issn, article.category, article.description, article.price);
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
        address(this).balance + msg.value;
        bytes32 queryId = oraclize_query("URL", "json(https://articledapp.azurewebsites.net/api/article).data.accepted", payload);
        
        pendingArticlesValidation[queryId] = id;
        
    }
    //----------------------------------------------------------------------------
    function getBalance() public returns (uint _balance) {
        return address(this).balance;
    }
    //----------------------------------------------------------------------------
    

//==========================================================================
}