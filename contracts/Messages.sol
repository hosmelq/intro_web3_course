// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract Messages {
  struct Message {
    uint256 id;
    string message;
    Reply[] replies;
    address sender;
    uint256 timestamp;
  }

  struct Reply {
    string message;
    address sender;
    uint256 timestamp;
  }

  event MessageCreated(Message message);
  event ReplyCreated(Reply reply);

  uint256 _index;
  uint256 private _seed;
  mapping(uint256 => Message) _messages;
  mapping(address => uint256) _lastMessageAt;

  constructor() payable {}

  function create(string memory _message) public {
    require(
      _lastMessageAt[msg.sender] + 15 minutes < block.timestamp,
      'Wait 15m'
    );

    _lastMessageAt[msg.sender] = block.timestamp;

    Message storage message = _messages[_index];

    message.id = _index;
    message.message = _message;
    message.sender = msg.sender;
    message.timestamp = block.timestamp;

    _index++;

    emit MessageCreated(message);

    /*
     * Generate a Psuedo random number between 0 and 100
     */
    uint256 randomNumber = (block.difficulty + block.timestamp + _seed) % 100;
    console.log('Random # generated: %s', randomNumber);

    _seed = randomNumber;

    if (randomNumber < 50) {
      console.log('%s won!', msg.sender);

      uint256 prizeAmount = 0.0001 ether;

      require(
        prizeAmount <= address(this).balance,
        'Trying to withdraw more money than the contract has.'
      );

      (bool success, ) = (msg.sender).call{value: prizeAmount}('');

      require(success, 'Failed to withdraw money from contract.');
    }
  }

  function reply(uint256 _id, string memory _message) public {
    Reply memory _reply = Reply({
      message: _message,
      sender: msg.sender,
      timestamp: block.timestamp
    });

    _messages[_id].replies.push(_reply);

    emit ReplyCreated(_reply);
  }

  function all() public view returns (Message[] memory) {
    Message[] memory messages = new Message[](_index);

    for (uint256 i = 0; i < _index; i++) {
      messages[i] = _messages[i];
    }

    return messages;
  }
}
