pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


contract AddProduct {
    uint public productNumber = 0;
    uint[] productListKeys;
    mapping(uint => Product) public productList;
    mapping(address => uint[]) sellerProducts;

    struct Product{
        uint productID;
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
        uint productID,
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
        productNumber ++;
        bool _active = true;
        if (_count == 0){
            _active = false;
        }
        Desc memory _details = Desc(_company,_desc);
        productListKeys.push(productNumber);
        productList[productNumber] = Product(productNumber, _name, _price, _count, _category, _details, msg.sender, _active);
        sellerProducts[msg.sender].push(productNumber);
        // Trigger an event
        emit ProductCreated(productNumber, _name, _price, _count, _category, _details, msg.sender, _active);
    }

    function deleteProduct(uint _productID) public {
        require(productExist(_productID),"Product does not exist");
        require(isSeller(_productID, msg.sender),"Only seller can delete product");
        for(uint i = 0;i<productListKeys.length;i++){
            if (productListKeys[i] == _productID){
                for(i;i<productListKeys.length-1;i++){
                    productListKeys[i] = productListKeys[i+1];
                }
                delete productListKeys[i];
                break;
            }
        }
        delete productList[_productID];
    }

    function changePrice(uint _productID,uint _price) public{
        require(productList[_productID].productID>0,"Product does not exist");
        require(_price>0,"Price Should be > 0");
        require(productList[_productID].seller == msg.sender,"Only seller can update price");
        productList[_productID].price = _price;
    }
    function changeCount(uint _productID,uint _count) public{
        require(productExist(_productID),"Product does not exist");
        require(isSeller(_productID, msg.sender),"Only seller can update price");
        productList[_productID].count = _count;
        if (_count == 0){
            productList[_productID].active = false;
        }
        else{
            productList[_productID].active = true;
        }
    }

    function decreaseCount(uint _productID,uint _decCount) public{
        require(productExist(_productID),"Product does not exist");
        require(getProductCount(_productID) > _decCount,"Count is too large");
        productList[_productID].count -= _decCount;
        if (productList[_productID].count <= 0){
            productList[_productID].active = false;
        }
    }
    function increaseCount(uint _productID,uint _incCount) public{
        require(productExist(_productID),"Product does not exist");
        productList[_productID].count += _incCount;
        if (productList[_productID].count > 0){
            productList[_productID].active = true;
        }
    }
    
    function isSeller(uint _productID,address _addr) public view returns (bool){
        if (productList[_productID].seller == _addr)
            return true;
        return false;
    }
    
    function productExist(uint _productID) public view returns (bool){
        if (productList[_productID].productID > 0)
            return true;
        return false;
    }

    function getProductPrice(uint _productID) public view returns (uint){
        return productList[_productID].price;
    }
    function getProductCount(uint _productID) public view returns (uint){
        return productList[_productID].count;
    }
    function getProductSeller(uint _productID) public view returns (address payable){
        return productList[_productID].seller;
    }
    function getSellerProducts() public view returns (uint[] memory productNum){
        productNum = sellerProducts[msg.sender];
    }
}