pragma solidity ^0.4.24;

contract CryptoArticleFactory {

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
        bool isPurchaseAvaliable;
        mapping (uint => Buyer) buyers; //represents a set of address that can read the article
        mapping (address => uint) addressToBuyer;
    }

    mapping (uint => address) internal articleToOwner;
    mapping (bytes32 => uint) internal pendingArticlesValidation;

    Article[] internal articles;

    //event NewArticle(uint articleId, string title, string author, string issn, string category, string description, uint price);

    function _createArticle(
        string _title, string _author, string _issn, string _category, 
        string _description, string _filePath, uint _price) internal returns (uint) {

        uint id = articles.push(Article(_title, _author, _issn, _category, _description, _filePath, _price, false, 0, 0)) - 1;
        articleToOwner[id] = msg.sender;     
        return id;       
    }


}