// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.6;  


 contract KYC{

 address  AdminAddress ;
 uint public CustumerCount = 0;


 modifier OnlyKYC{
    require(msg.sender == AdminAddress,"Only Admin of KYC can Access");
    _;}  


constructor(){
    AdminAddress = msg.sender;}


struct Bank{
    string BankName;
    address BankAdd;
    uint KycCount ;
    bool KycAllowance;
    bool AllowCustumerToAddBank;}



struct Custmer{
  
  string CustName;
  uint CustDataId;
  bool kycStatus;
  address AllowancedBank;}


mapping (address => Bank)Banks;
mapping (string => Custmer)CustInfo;


//Adding new bank that approved by KYC only can create.
//Same name  of bank cant be allowed.
function FristAddNewBankFromKYC(string memory _BankName,address _BankAdd)public OnlyKYC{

require (!notSameNameIsRepeat(_BankName,Banks[_BankAdd].BankName)," Bank name as already exist");

   Banks[_BankAdd]=Bank(_BankName,_BankAdd,0,true,true); }



//it function to avoid same bank name.
function notSameNameIsRepeat(string memory x,string memory  y)private pure returns(bool failed) {
    if(bytes(x).length != bytes (y).length){
        return failed;
    }} 



//custumer details are uploaded here [(custID)-contain all details of custumer].
//if ur bank is blocked then u cant upload custumer details untill it unblocked.
function SecoundaddDataOfCustToBank(string memory  CustName,uint  CustDataId  )public  OnlyKYC{

    require( CustInfo[CustName].AllowancedBank == address(0),"This address already excist");

     require(Banks[msg.sender].KycAllowance,"this bank does not have kyc allowance");

    CustumerCount += 1;

    CustInfo[CustName]=Custmer(CustName,CustDataId,false,msg.sender);}




//details of custmer any one can see..
function viewCustData(string memory CustName)public view returns(string memory name , uint CustId , bool kycstatus){

    require( CustInfo[CustName].AllowancedBank != address(0),"Entered custumer address not found"); 

   return (CustInfo[CustName].CustName,CustInfo[CustName].CustDataId,CustInfo[CustName].kycStatus);}




//only KYC can approve the custumer account..
function ThridGetApprovalOfCustAccountFromKYC(string memory CustName) public  OnlyKYC{

    require(Banks[msg.sender].KycAllowance,"this bank does not have kyc allowance");

    CustInfo[CustName].kycStatus= true;

    Banks[msg.sender].KycCount += 1;}




// you can track your status of KYC approval..
function TrakerOfKycStatus(string memory CustName)public view returns(bool){

 require( CustInfo[CustName].AllowancedBank != address(0),"Entered address not found");

return CustInfo[CustName].kycStatus;}




//if u blocked bank then u can unblock the bank from KYC...
function UnblockBankFromKYC(address _BankAdd)public  OnlyKYC  returns(uint){

require (Banks[_BankAdd].BankAdd  != address(0),"Entered address not found");

 Banks[_BankAdd].KycAllowance = true;

 return 1;}




//if want u can block the banks ....
function BlockBankFromKYC(address _BankAdd)public OnlyKYC returns(uint ){

require (Banks[_BankAdd].BankAdd != address(0),"Entered address not found");

 Banks[_BankAdd].KycAllowance = false;

 return  0;}



//if u blocked the custumer account then u can ,if want to unblock the custumer account..
function UnblockNewCustToAddBankFromKYC(address _BankAdd)public OnlyKYC returns(string memory){

require (Banks[_BankAdd].BankAdd  != address(0),"Entered address not found");

require(!Banks[_BankAdd].AllowCustumerToAddBank,"");

Banks[_BankAdd].AllowCustumerToAddBank = true;

return " Your Account is sucessfully unblocked ";}



//if u want block custumer account then u can...
function BlockCustToAddBank(address _BankAdd)public OnlyKYC returns(string memory){

require (Banks[_BankAdd].BankAdd  != address(0),"Entered address not found");

require(Banks[_BankAdd].AllowCustumerToAddBank,"");

Banks[_BankAdd].AllowCustumerToAddBank = false;

return "You can not create account ";}}
