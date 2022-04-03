// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  event Stake(address staker, uint256 amount);

  ExampleExternalContract public exampleExternalContract;
  mapping (address => uint256) public balances;
  uint256 public constant threshold = 1 ether;
  bool public openForWithdraw;
  uint256 public deadline = block.timestamp + 72 hours;

  constructor(address exampleExternalContractAddress){
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  function stake() public payable {
      balances[msg.sender] += msg.value;
      emit Stake(msg.sender, msg.value);
  }
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )


  function execute() public {
    if (address(this).balance >= threshold && block.timestamp >= deadline){
      exampleExternalContract.complete{value: address(this).balance}();
    }
    else if (address(this).balance < threshold && block.timestamp >= deadline){
      openForWithdraw = true;
    }
  }

  function withdraw() public payable {
    address payable addr = payable(address(msg.sender));
    uint256 addr_balance = balances[msg.sender];
    balances[msg.sender] = 0;
    addr.transfer(addr_balance);
  }


  function timeLeft() public view returns(uint256){
    if (block.timestamp > deadline){
      return 0;
    }
    return deadline - block.timestamp;
  }


  receive() external payable {
    stake();
  }


}
