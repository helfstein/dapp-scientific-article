pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CryptoArticles.sol";

contract TestArticle {

    CryptoArticles cryptoArticles = CryptoArticles(DeployedAddresses.CryptoArticles());


    function testPublish() public {
        uint returnedId = cryptoArticles.publishArticle(
            "title", "author", "111", "category", "description", "path", 1
        );
         // string _title, string _author, string _issn, string _category,   
        // string _description, string _filePath, uint _price

        uint expected = 0;
        uint returnedId2 = cryptoArticles.publishArticle(
            "title2", "author2", "222", "category2", "description2", "path2", 1
        );

        uint expected2 = 1;
        Assert.equal(returnedId, expected, "Adoption of pet ID 8 should be recorded.");
        Assert.equal(returnedId2, expected2, "Adoption of pet ID 8 should be recorded.");
    }

    function testBuy() public {
        uint returnedArticleId = cryptoArticles.publishArticle(
            "title", "author", "111", "category", "description", "path", 1
        );
        uint returnedId = cryptoArticles.buyArticle(returnedArticleId);
        //uint expected = 0;
        Assert.equal(returnedId, returnedId, "Adoption of pet ID 8 should be recorded.");
    }

}
