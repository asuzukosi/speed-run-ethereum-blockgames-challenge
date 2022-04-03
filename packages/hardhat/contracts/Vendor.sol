pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  uint256 public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() public payable {
    uint256 amountOfTokens = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amountOfTokens);
    emit BuyTokens(msg.sender, msg.value, amountOfTokens);
      
  }

  function withdraw() public onlyOwner {
    uint256 amount = address(this).balance;

    address payable addr = payable(address(msg.sender));
    addr.transfer(amount);
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount_of_tokens) public {
    yourToken.transferFrom(msg.sender, address(this), amount_of_tokens);

    // calculate eth to send at the current rate
    uint256 amountOfETH = amount_of_tokens / tokensPerEth;

    // send the ETH to the seller
    address payable addr = payable(address(msg.sender));
    addr.transfer(amountOfETH);
  }

}

