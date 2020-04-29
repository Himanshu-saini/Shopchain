pragma solidity ^0.6.0;

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

    event accountCreated{
        string name;
        address payable account;
        string location;
        string phone;
        string email;
        string accountType;
    }
    
    function createUser(string _name, string _location, string _phone, string _email,string _type) public {
        require(bytes(_name).length > 0);
        require(bytes(_location).length > 0);
        require(bytes(_phone).length > 9);
        require(bytes(_email).length > 0);
        require(_type = "buyer" || _type = "seller");

        userAccount[msg.sender] = User(_name,msg.sender,_location,_phone,_email, _type)

        emit accountCreated(_name,msg.sender,_location,_phone,_email,_type)
    }

}