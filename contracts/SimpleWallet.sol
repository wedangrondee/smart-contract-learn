// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Allowance.sol";

contract SimpleWallet is Allowance{
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceive(address indexed _from, uint _amount);
    
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount){
        require(_amount <= address(this).balance,"There are not enough fund stored in the smart contract");
        if(!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership()public override onlyOwner{
        revert("Can't renounceOwnerShip");
    }

    receive ()external payable{
        emit MoneyReceive(msg.sender, msg.value);
    }
}