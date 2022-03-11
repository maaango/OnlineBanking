// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.6;
contract Escrew{

//variables
bool public InSeller;
bool public Inbuyer;

uint price;
address payable public seller;
address payable public buyer;

enum track{NOT_INIT_CONTRACT,AWAITING_PAYMENT,AWAITING_DELIVERY,DELEVERY_COMPLETED,MONEY_RETURNED}

track public CurrentTrack;

//modifier
modifier onlyBuyer{
    require(msg.sender == buyer); _;}

modifier onlyEscrew{
    require(CurrentTrack == track.NOT_INIT_CONTRACT); _;
}    


constructor(uint _price,address payable  _buyer,address payable  _seller){
    price =_price *(1 ether);
    seller =_seller;
    buyer = _buyer;}

//both buyer and seller accept then contract is initiatited..
function initiateContract()public onlyEscrew{

    require(buyer != seller);

if(msg.sender == buyer){Inbuyer = true;}

if(msg.sender == seller){InSeller = true;}

if(Inbuyer && InSeller){

CurrentTrack = track.AWAITING_PAYMENT;}}

//2ND buyer have to enter the value give at constructor...
function deposite()public payable onlyBuyer{

    require(CurrentTrack == track.AWAITING_PAYMENT,"contract not initicated");

    require(msg.value == price,"deposit price is wrong");

   CurrentTrack = track.AWAITING_DELIVERY; }


//if u want product u can give complete the delivery After u giving complete Delivery the amount will be sent to seller ..
//untill the amount in deposit function..
   function completeDelivery()public payable onlyBuyer{
       
       require(CurrentTrack == track.AWAITING_DELIVERY,"cannot conforim delivery");

          seller.transfer(price );
       CurrentTrack = track.DELEVERY_COMPLETED; }
// if u not recevied the product or some thing else u can cancel the order.....
function orRetrunBackDelivery()public payable{

     require(CurrentTrack == track.AWAITING_DELIVERY,"cannot return Delivery at this stage");

  payable (buyer).transfer(price );
}}