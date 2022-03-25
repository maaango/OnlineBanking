// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.2;

contract pubg{

// Dealer how runs the tournament amoung the players...
address public Dealer;
uint playerCount;


constructor(){
Dealer = msg.sender;}


enum level{basic,medeium,hard}

//all player pay entry fee to enter the game...
uint public lobby;

struct player{
address playerAddress;
string  playerName;
level playerLevel;
uint creationTime;
}

mapping (address => player)public players;

player[] public playersingame;

event winnerReward(address ,uint );



//this is called private because every player should pay entry fee.This function is linked with JoinPlayer function...
function addPlayers(string memory name)private{

require(players [msg.sender].playerAddress == address(0),"Already player exist");

player memory newPlayer = player(msg.sender,name,level.medeium,block.timestamp);

players[msg.sender]= newPlayer;

playersingame.push(newPlayer);}






//can see the details of player..
function seePlayers(address playerAddress)public view returns(string memory, level, uint){

return(players [playerAddress].playerName,players[playerAddress].playerLevel,players[playerAddress].creationTime);}





//to join the game , player as to pay entry fee .that,fee is stored lobby after game play winners will share the rewards...
function joinPlayer(string memory name)public payable{

    require (msg.value == 5 ether, " to join transfer 25 ether to dealer");

    if(payable(Dealer).send(msg.value)){

        addPlayers (name);

        playerCount += 1;

        lobby +=5; }}





//one player will be the looser rest all share their reward 
function payForWinners(address losserAddress)public payable{

 require(msg.sender == Dealer, " only dealer can pay for win players ");

 require ( msg.value == lobby *(1 ether),"Insufficient Ether");


    uint payOutPerWinner = msg.value/(playerCount -1);

    for(uint i=0; i<playersingame.length;i++){

   address  currentPlayer = playersingame[i].playerAddress;
         if(currentPlayer != losserAddress)
        {
         payable (currentPlayer).transfer (payOutPerWinner);
         emit winnerReward(currentPlayer,msg.value);
         }}}}