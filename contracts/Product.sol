pragma solidity ^0.5.0;

contract Product {
    unit public totalCategory = 0;
    mapping(string => uint) public categoryCount;

    struct Product {
        uint id;
        string name;
        uint price;
        uint count;
        string category;
        uint rating;
        Desc details;
        address payable owner;
        bool active;
    }

    struct Desc {
        string color;
        Dimensions size;
        string location;
        uint weight;
        string company;
        string description;
    }

    struct Dimensions{
        uint length;
        uint breadth;
        uint height;
    }

    event ProductCreated(
        uint id;
        string name;
        uint price;
        uint count;
        string category;
        uint rating;
        Desc details;
        address payable owner;
        bool active;
    );

    function createProduct(string memory _name, uint _price) public {
        require(bytes(_name).length > 0);
        require(_price > 0);
        productCount ++;
        
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }
}