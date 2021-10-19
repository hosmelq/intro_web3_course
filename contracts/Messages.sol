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
  mapping(uint256 => Message) _messages;

  function create(string memory _message) public {
    Message storage message = _messages[_index];

    message.id = _index;
    message.message = _message;
    message.sender = msg.sender;
    message.timestamp = block.timestamp;

    _index++;

    emit MessageCreated(message);
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
