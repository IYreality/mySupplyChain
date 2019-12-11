pragma solidity ^0.4.11;

contract test{
    address public manager;
    
    struct Company{
        string name;
        address owner;//the company's address
        uint balance;
        
    }
    mapping(address => Company) public companys;    
    
    struct Receipt{
        address Arrears;//from
        address Payee;//to
        uint id;//the receipt id
        uint amount;//the amount
        bool finished;//if the receipt was payed
        bool status;//if bank admit this receipt
        Company owner;//can be sent to others
    }
    

    Receipt[] public receipts;//so many receipts
    
    constructor(string name)public{
        // msg.sender;
    }
    
   
/*Function 1: Realize the purchase of goods - issue accounts receivable and trade on the chain. For example, a car company buys a batch of tires from a tire company.Sign the accounts receivable statement.*/
    function purchase(address to,uint id,uint amount,bool status) public{
        Company sender = companys[msg.sender];
        require(!receipts[id].finished);
        receipts[id].Arrears = sender;
        receipts[id].Payee = to;
        receipts[id].amount = amount;
        receipts[id].finished = false;
        receipts[id].status = status;
        receipts[id].owner = companys[to];
    }
/*Function 2: Realizing the transfer of accounts receivable, the tire company buys a wheel hub from the wheel hub company, it will be the car company.The accounts receivable document is partially transferred to the hub company. Wheel companies can use this new document to finance or require car companies to Time to return the money.*/
    function transfer(address to,uint id) public{
        receipts[id].owner = companys[to];
    }
/*Function 3: Use the accounts receivable to finance the bank, all the supply chain can use the accounts receivable documents to apply to the bank.Please raise funds.*/
    function request(uint id)public{
        
    }
    
    function finance(uint id,address to) public{
        require((msg.sender == bank) );//if it's bank
        if(receipts[id].status && receipts[id].finished){
            sent(to,receipts[id].amount);
        }
            
    }
/*Function 4: Accounts receivable payment settlement is on the chain, the core enterprise pays the corresponding owed to the downstream enterprise when the accounts receivable document expires paragraph.*/
        //transfer the money
    function sent(address receiver,uint id,uint amount) public {
        if(balances[msg.sender]<amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender,receiver,amount);
        
        companys[receiver].balance += amount;
        receipts[id].finished = true;
    } 
    
}
