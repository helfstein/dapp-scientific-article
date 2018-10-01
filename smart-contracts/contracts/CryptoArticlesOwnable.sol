pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./CryptoArticleFactory.sol";

contract CryptoArticlesOwnable is Ownable, CryptoArticleFactory {

    mapping (uint => address) articlesApprovals;

    modifier onlyOwnerOfArticle(uint articleID) {
        // .addressToBuyer[msg.sender];
        require(articleToOwner[articleID] == msg.sender, "Access denied");
        _;
    }

    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerArticleCount[_owner]; //returns how many tokens a owner has
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return articleToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerArticleCount[_to]++;
        ownerArticleCount[_from]--;
        articleToOwner[_tokenId] = _to;
        //emit a new event for transfer articles
        //emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _from, address _to, uint256 _tokenId) public onlyOwnerOfArticle(_tokenId) {
        _transfer(_from, _to, _tokenId);
    }
      
    function approve(address _to, uint256 _tokenId) public onlyOwner() {
        articlesApprovals[_tokenId] = _to;
        //Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
		require(articlesApprovals[_tokenId] == msg.sender);
		address owner = ownerOf(_tokenId);
		_transfer(owner, msg.sender, _tokenId);
    }
}