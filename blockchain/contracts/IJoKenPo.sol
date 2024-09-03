// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import "./JKPLibrary.sol";

interface IJoKenPo2 {


    function getResult() external view returns (string memory);

    function getBid() external view returns (uint256);

    function getCommission() external view returns (uint8);

    function setBid(uint256 newBid) external;

    function setCommission(uint8 newCommission) external;

    function getBalance() external view returns (uint);

    function play(JKPLIbrary.Options newChoice) external payable returns (string memory);

    function getLeaderBorder() external view returns (JKPLIbrary.Player[] memory);
}
