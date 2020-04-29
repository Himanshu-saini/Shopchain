pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract AddProduct {
    uint public totalProduct = 0;
    mapping(uint => Product) public productList;

    struct Product{
        uint id;
        string name;
        uint price;
        uint count;
        string category;
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

    function createProduct(string memory _name, uint _price,uint _count,string memory _category,string memory _company, string memory _desc) public {
        require(bytes(_name).length > 0,"Name Cannot be Empty");
        require(_price > 0, "Price must be > 0");
        totalProduct ++;
        bool _active = true;
        if (_count == 0){
            _active = false;
        }
        Desc memory _details = Desc(_company,_desc);

        productList[totalProduct] = Product(totalProduct, _name, _price, _count, _category, _details, msg.sender, _active);
        // Trigger an event
        emit ProductCreated(totalProduct, _name, _price, _count, _category, _details, msg.sender, _active);
    }

    function changePrice(uint _id,uint _price) public{
        require(productList[_id].id>0,"Product does not exist");
        require(_price>0,"Price Should be > 0");
        require(productList[_id].seller == msg.sender,"Only seller can update price");
        productList[_id].price = _price;
    }
    function changeCount(uint _id,uint _count) public{
        require(productList[_id].id>0,"Product does not exist");
        require(productList[_id].seller == msg.sender,"Only seller can update price");
        productList[_id].count = _count;
        if (_count == 0){
            productList[_id].active = false;
        }
        else{
            productList[_id].active = true;
        }
    }

    function decreaseCount(uint _id,uint _decCount) public{
        require(productList[_id].id > 0,"Product does not exist");
        require(productList[_id].count > _decCount,"Count is too large");
        productList[_id].count -= _decCount;
        if (productList[_id].count <= 0){
            productList[_id].active = false;
        }
    }
    function increaseCount(uint _id,uint _incCount) public{
        require(productList[_id].id > 0,"Product does not exist");
        productList[_id].count += _incCount;
        if (productList[_id].count > 0){
            productList[_id].active = true;
        }
    }
}