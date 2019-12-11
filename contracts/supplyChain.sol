pragma solidity ^0.4.11;

contract supplyChain{
    address public manager;
    
    struct Company{
        string name;
        address owner;//the company's address
    }
//every company only has one address and balance   
    mapping (address => uint) public balances; 
    mapping (address => Company) public companys;

    struct Receipt{
        address Arrears;//from
        address Payee;//to
        uint amount;//the amount
        bool finished;//if the receipt was payed by bank
        bool status;//if bank admit this receipt
        address owner;//can be sent to others
    }
    Receipt[] public receipts;
    //every receipt has a id
    
    function setChainManager(){
        manager = msg.sender;
    }
    //send distrectly
    event Sent(address from, address to, uint amount);
    function send(address receiver, uint amount) public {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    } 
    
    //functin 1
    function issue(address receiver, uint _amount,bool _status)public{
        receipts.push(Receipt({
            Arrears : msg.sender,
            Payee : receiver,
            amount : _amount,
            finished : false,
            status : _status,
            owner : receiver
        }));
    }
    
    //function 2
    function transfer(uint id,address receiver)public{
        if(receipts[id].owner == msg.sender){
            receipts[id].owner = receiver;
        }
    }
    //function 3
    function finance(uint id)public {
        if(receipts[id].status == true && receipts[id].finished == false){
            balances[msg.sender] += receipts[id].amount;
            receipts[id].finished = true;
            receipts[id].owner = receipts[id].Arrears;//give back the receipt to the issuer
        }
    }
    function payback(uint amount)public{
        //give back money to the bank
        balances[msg.sender] -= amount;
        //bank's balance ++
    }
    //set init balance
    function setBalance(uint number)public{
        if(msg.sender == manager )//only manager can set init balance
         balances[msg.sender] += number;
    }
    //set company name ,only manager and the self company can setname
    function setName(address company,string name)public {
        if(company == msg.sender || company == manager){
            companys[company].name = name;            
        }
    }
    function queryBalance(address company) constant returns (uint) {
        return balances[company];
    }
    
    function queryFinished(uint id) public returns (bool) {
        return receipts[id].finished;
    }
    //function 4
    function pay(uint id) public{
        if(receipts[id].Arrears == msg.sender){
            if (balances[msg.sender] < receipts[id].amount) return;
            balances[msg.sender] -= receipts[id].amount;
            balances[receipts[id].Payee] += receipts[id].amount;
            emit Sent(msg.sender, receipts[id].Payee, receipts[id].amount);
            receipts[id].owner = msg.sender;
        }
    }
  
    mapping (uint => address) public owners;
    event LogAddress(string,address);
    function log(string s,address company)internal{
        if(company == manager){
            for(uint i = 0;i < receipts.length;i++)
            emit LogAddress(s,owners[i]);
        }
    }


}
