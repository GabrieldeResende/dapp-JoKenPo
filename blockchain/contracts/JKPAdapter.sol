// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import "./IJoKenPo.sol";
import "./JKPLibrary.sol";

contract JKPAdapter {
    IJoKenPo2 private joKenPo;
    address public immutable owner;

    event Played(address indexed player, string result);

    constructor() {
        owner = msg.sender;
    }

    function getImplementationAddress() external view returns (address) {
        return address(joKenPo);
    }

    function getBid() external view upgraded returns (uint256) {
        return joKenPo.getBid();
    }

    function getCommission() external view upgraded returns (uint8) {
        return joKenPo.getCommission();
    }

    function setBid(uint256 newBid) external upgraded restricted {
        return joKenPo.setBid(newBid);
    }

    function setCommission(uint8 newCommission) external upgraded restricted {
        return joKenPo.setCommission(newCommission);
    }

    function getBalance() external view upgraded returns (uint) {
        return joKenPo.getBalance();
    }

    function getResult() external view upgraded returns (string memory) {
        return joKenPo.getResult();
    }

    function play(JKPLIbrary.Options newChoice) external payable upgraded {
        string memory result = joKenPo.play{value: msg.value}(newChoice);
        emit Played(msg.sender, result);
    }

    function getLeaderBorder()
        external
        view
        upgraded
        returns (JKPLIbrary.Player[] memory)
    {
        return joKenPo.getLeaderBorder();
    }

    function upgrade(address newImplementation) external restricted {
        require(
            address(0) != newImplementation,
            "Empty address is not permitted"
        );
        joKenPo = IJoKenPo2(newImplementation);
    }

    modifier restricted() {
        require(owner == msg.sender, "You do not have permission");
        _;
    }

    modifier upgraded() {
        require(address(joKenPo) != address(0), "You must upgrade first");
        _;
    }
}
