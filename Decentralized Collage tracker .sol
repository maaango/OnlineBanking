
// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.6;



contract Collage{


address Central;
uint public GetStudentCount = 0;
uint public CollageCount = 0;

 modifier OnlyCentral{
   require (msg.sender == Central,"only owner can access");
    _;}

constructor(){
    Central = msg.sender;}


struct CollageDetails{
    string CollageName;
    address CollageAddress;
    bool AllowToAddStudent;
    uint RegNo;}


struct StudentDetails{
       address StudentAddress;
       string StudentName;
       string StudentCourse;
       uint MobileNo;}

 mapping (string =>StudentDetails) _StudentDetails;
 mapping (address =>CollageDetails) _CollageDetails;


//upload the collage details only the central athority can ...
function AuploadCollageDetails (string memory  _CollageName,address _CollageAddress,uint _RegNo)
  OnlyCentral  public{

require (!NotSameCollageName(_CollageName,_CollageDetails[_CollageAddress].CollageName),"This name already entered");

_CollageDetails[_CollageAddress]= CollageDetails(_CollageName,_CollageAddress,true, _RegNo);

CollageCount += 1;}



//not same collage name can entered!...
function NotSameCollageName(string memory a, string memory b)private pure returns(bool failed){

    if (bytes (a).length !=  bytes (b).length){
      return failed;}}



//View details of collage you uploaded...
function ViewCollageDetails(address _CollageAddress)public view returns(string memory _CollageName, uint _RegNo){

return (_CollageDetails[_CollageAddress].CollageName,_CollageDetails[_CollageAddress].RegNo);}



// upload the student details ..
function SetStudentDetails(address StudentAddress,string memory  StudentName,
    string memory StudentCourse,uint MobileNo )public  {

 GetStudentCount += 1;

_StudentDetails[StudentName] = StudentDetails(StudentAddress, StudentName, StudentCourse, MobileNo);}



//view the details of student uploaded according to collage...
function ViewStudentDetails(string memory StudentName)public view returns(address,string memory,uint){

return(_StudentDetails[StudentName].StudentAddress,
       _StudentDetails[StudentName].StudentCourse,
       _StudentDetails[StudentName].MobileNo);}



//can change the course if student want ...
function ChangeStudentCourse(string memory StudentName, string memory _CourseNameToChange )public {

require(_StudentDetails[StudentName].StudentAddress != address(0));

 
_StudentDetails[StudentName].StudentCourse =_CourseNameToChange;}



// Athority can unblocking the collage to add more students .if want...
function UnblockCollageToAddStudent(address _CollageAddress)public OnlyCentral returns(uint){

require(_CollageDetails[_CollageAddress].CollageAddress != address(0),"address not found");

require(!_CollageDetails[_CollageAddress].AllowToAddStudent,"already unblocked");

_CollageDetails[_CollageAddress].AllowToAddStudent = true; 

return 1;}



//Athority can block the collage to stop adding student...
function blockCollageToAddStudent(address _CollageAddress)public OnlyCentral returns(uint){

require(_CollageDetails[_CollageAddress].CollageAddress != address(0),"address not found");

require(_CollageDetails[_CollageAddress].AllowToAddStudent,"already blocked");

_CollageDetails[_CollageAddress].AllowToAddStudent = false; 

return 0;}
}


