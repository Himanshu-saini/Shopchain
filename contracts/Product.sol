pragma solidity ^0.6.0;

contract AddProduct {
    uint public totalProduct = 0;
    mapping(string => uint) public productList;

    struct Product{
        uint id;
        string name;
        uint price;
        uint count;
        string category;
        uint rating;
        Desc details;
        address payable seller;
        bool active;
    }

    struct Desc {
        string company;
        string description;
    }

    event ProductCreated(
        uint id,
        string name,
        uint price,
        uint count,
        string category,
        Desc details,
        address payable seller,
        bool active
    );

    function createProduct(string memory _name, uint _price,unit _count,string _category,string _company, string _desc) public {
        require(bytes(_name).length > 0,"Name Cannot be Empty");
        require(_price > 0, "Price must be > 0");
        productCount ++;
        bool _active = true;
        if (_count == 0){
            _active = false;
        }
        Desc _details = new Desc(_company,_desc);

        productList[productCount] = Product(productCount, _name, _price, _count, _category,, _details, msg.sender, _active);
        // Trigger an event
        emit ProductCreated(productCount, _name, _price, _count, _category, _rating, _details, msg.sender, _active);
    }

    function changePrice(uint _id,uint _price) public{
        require(productList[id].id>0,"Product does not exist");
        require(_price>0,"Price Should be > 0");
        require(productList[id].seller == msg.sender,"Only seller can update price");
        productList[id].price = _price;
    }
    
    function changeCount(uint _id,uint _count) public{
        require(productList[id].id>0,"Product does not exist");
        require(productList[id].seller == msg.sender,"Only seller can update price");
        productList[id].count = _count;
        if (_count == 0){
            productList[id].active = false;
        }
        else{
            productList[id].active = true;
        }
    }

    function decreaceCount(uint _id,uint _count) public{
        require(productList[id].id > 0,"Product does not exist");
        require(productList[id].count > _count,"Count is too large");
        productList[id].count -= _count;
        if (productList[id].count == 0){
            productList[id].active = false;
        }
    }
}