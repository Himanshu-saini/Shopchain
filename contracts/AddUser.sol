pragma solidity ^0.5.0;

contract AddUser{

    struct User{
        string name;
        address payable account;
        string location;
        string phone;
        string email;
        string accountType;
    }

    mapping(address => User) public userAccount;

    event accountCreated(
        string name,
        address payable account,
        string location,
        string phone,
        string email,
        string accountType
    );
    
    function createUser(string memory _name, string memory _location, string memory _phone, string memory _email,string memory _type) public {
        require(bytes(_name).length > 0,"Name Length must be > 0");
        require(bytes(_location).length > 0,"location Length must be > 0");
        require(bytes(_phone).length > 9,"Phone Length must be > 9");
        require(bytes(_email).length > 0,"Email Length must be > 0");

        userAccount[msg.sender] = User(_name,msg.sender,_location,_phone,_email, _type);

        emit accountCreated(_name,msg.sender,_location,_phone,_email,_type);
    }

}