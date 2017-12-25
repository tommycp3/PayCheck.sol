pragma solidity ^0.4.0;

contract PayCheck {
    address[] employees = [0x14723a09acff6d2a60dcdf7aa4aff308fddc160c, 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db, 0x583031d1113ad414f02576bd6afabfb302140225, 0xdd870fa1b7c4700f2bd7f44238821c26f7392148];
    uint totalReceived = 0;
    mapping (address => uint) withdrawnAmounts;
    
    function PayCheck() payable {
        updateTotal();
    }
    function () payable {
        updateTotal();
    }
    
    function updateTotal() internal {
        totalReceived += msg.value;
    }
    
    modifier canWidthdraw() {
        bool contains = false;
        
        for(uint i = 0; i < employees.length; i++) {
            if(employees[i] == msg.sender) {
                contains = true;
            }
        }
        require(contains);
        _;
    }
    
    function withdraw() canWidthdraw {
        uint amountAllocated = totalReceived/employees.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;
        if (amount > 0) {
            msg.sender.transfer(amount);
        }
    }
    
}