// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./IJoKenPo.sol";
import "./JKPLibrary.sol";

contract JoKenPo2 is IJoKenPo2 {
    JKPLIbrary.Options private choice1 = JKPLIbrary.Options.NONE;
    address private player1;
    string private result = "";
    uint256 private bid = 0.01 ether;
    uint8 private commission = 10; //percent

    address payable private immutable owner;

    JKPLIbrary.Player[] public players;

    constructor() {
        owner = payable(msg.sender);
    }

    function getResult() external view returns (string memory) {
        return result;
    }

    function getBid() external view returns (uint256) {
        return bid;
    }

    function getCommission() external view returns (uint8) {
        return commission;
    }

    function setBid(uint256 newBid) external {
        require(tx.origin == owner, "You dont have permission");
        require(
            player1 == address(0),
            "You cannot change the bid with a game in progress"
        );
        bid = newBid;
    }

    function setCommission(uint8 newCommission) external {
        require(tx.origin == owner, "You dont have permission");
        require(
            player1 == address(0),
            "You cannot change the commission with a game in progress"
        );
        commission = newCommission;
    }

    function updateWinner(address winner) private {
        for (uint i = 0; i < players.length; i++) {
            if (players[i].wallet == winner) {
                players[i].wins++;
                return;
            }
        }
        players.push(JKPLIbrary.Player(winner, 1));
    }

    function finishiGame(string memory newResult, address winner) private {
        address contractAddress = address(this);
        payable(winner).transfer(
            (contractAddress.balance / 100) * (100 - commission)
        );
        owner.transfer(contractAddress.balance);

        updateWinner(winner);

        result = newResult;
        player1 = address(0);
        choice1 = JKPLIbrary.Options.NONE;
    }

    function getBalance() external view returns (uint) {
        require(owner == tx.origin, "You dont have permission");
        return address(this).balance;
    }

    function play(JKPLIbrary.Options newChoice) external payable returns (string memory) {
        require(tx.origin != owner, "The owner can not play");
        require(newChoice != JKPLIbrary.Options.NONE, "Invalid Choice");
        require(player1 != tx.origin, "Wait the another player");
        require(msg.value >= bid, "Invalid bid");

        if (choice1 == JKPLIbrary.Options.NONE) {
            player1 = tx.origin;
            choice1 = newChoice;
            result = "Player 1 choice his/her option. Waiting for player 2";
        } else if (
            choice1 == JKPLIbrary.Options.ROCK &&
            newChoice == JKPLIbrary.Options.SCISSORS
        ) {
            finishiGame("Player 1 WON", player1);
        } else if (
            choice1 == JKPLIbrary.Options.PAPER &&
            newChoice == JKPLIbrary.Options.ROCK
        ) {
            finishiGame("Player 1 WON", player1);
        } else if (
            choice1 == JKPLIbrary.Options.SCISSORS &&
            newChoice == JKPLIbrary.Options.PAPER
        ) {
            finishiGame("Player 1 WON", player1);
        } else if (
            choice1 == JKPLIbrary.Options.SCISSORS &&
            newChoice == JKPLIbrary.Options.ROCK
        ) {
            finishiGame("Player 2 WON", tx.origin);
        } else if (
            choice1 == JKPLIbrary.Options.ROCK &&
            newChoice == JKPLIbrary.Options.PAPER
        ) {
            finishiGame("Player 2 WON", tx.origin);
        } else if (
            choice1 == JKPLIbrary.Options.PAPER &&
            newChoice == JKPLIbrary.Options.SCISSORS
        ) {
            finishiGame("Player 2 WON", tx.origin);
        } else {
            result = "Draw game, prize doubled";
            player1 = address(0);
            choice1 = JKPLIbrary.Options.NONE;
        }
        return result;
    }

    function getLeaderBorder()
        external
        view
        returns (JKPLIbrary.Player[] memory)
    {
        if (players.length < 2) return players;

        JKPLIbrary.Player[] memory arr = new JKPLIbrary.Player[](
            players.length
        );

        for (uint i = 0; i < players.length; i++) {
            arr[i] = players[i];
        }
        for (uint i = 0; i < arr.length - 1; i++) {
            for (uint j = 1; j < arr.length; j++) {
                if (arr[i].wins < arr[j].wins) {
                    JKPLIbrary.Player memory change = arr[i];
                    arr[i] = arr[j];
                    arr[j] = change;
                }
            }
        }
        return arr;
    }
}
