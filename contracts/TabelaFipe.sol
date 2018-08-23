/*
   Consutar Tabela Fipe
*/

pragma solidity ^0.4.0;
import "./oraclize/usingOraclize.sol";

contract TabelaFipe is usingOraclize {
    
    //uint id;
    string public marca;
    //string modelo;
    //string ano;
    
    event newOraclizeQuery(string description);
    event resultMarcaCarro(string marca);

    function artigo() public {
        consultar();
    }
    
    function __callback(bytes32 myid, string result) public {
        if (msg.sender != oraclize_cbAddress())
            revert("");
        marca = result;
        emit resultMarcaCarro(marca);
    }
    
    function consultar() public payable {
        emit newOraclizeQuery("Consutar Tabela Fipe");
        oraclize_query("URL", "json(http://fipeapi.appspot.com/api/1/carros/veiculo/21/4828/2013-1.json).marca");
    }
} 
                                           
