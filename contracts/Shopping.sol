pragma solidity ^0.5.0;

import './AddProduct.sol';

contract Shopping {
    AddProduct productContract;                 // contract instance
    mapping(uint => Order) public orderList;            // All orders
    mapping(address => uint[]) public buyerList;     // For Buyer
    mapping(address => uint[]) public sellerList;       // For Seller
    uint orderNumber = 1000;                   // For Order Number
    struct Order{
        uint orderID;
        uint productID;
        uint count;
        uint amount;
        address payable buyer;
        uint status;
    }

    constructor(address _addr) public{
        productContract = AddProduct(_addr);
    }

    event orderPlaced(
        uint orderID,
        uint productID,
        uint count,
        uint amount,
        address buyer,
        uint status
    );
    function getbalance() public view returns(uint){
        return address(this).balance;
    }

    function orderExist(uint _orderNumber) public view returns (bool){
        if (orderList[_orderNumber].orderID > 0)
            return true;
        return false;
    }

    function placeOrder(uint _productID,uint _count) public payable returns (bool){
        require(productContract.productExist(_productID),"Invalid product number");
        require(!productContract.isSeller(_productID,msg.sender),"Buyer cannot be Seller");
        require(_count <= productContract.getProductCount(_productID) ,"Supply insufficient for purchase");
        require(msg.value > productContract.getProductPrice(_productID) * _count,"Fund insufficient for purchase");
        
        uint _status = 101;
        orderNumber ++;
        orderList[orderNumber] = Order(orderNumber, _productID, _count, msg.value,msg.sender, _status);
        buyerList[msg.sender].push(orderNumber);
        sellerList[productContract.getProductSeller(_productID)].push(orderNumber);
        productContract.decreaseCount(_productID,_count);
        emit orderPlaced(orderNumber,_productID,_count,msg.value,msg.sender,_status);
    }

    function purchaseComplete(uint _orderNumber) public {
        require(orderExist(_orderNumber),"Order does not exist");
        require(orderList[_orderNumber].status == 101,"Order Not Active");
        Order memory currentOrder = orderList[_orderNumber];
        address payable _seller = productContract.getProductSeller(currentOrder.productID);
        _seller.transfer(currentOrder.amount);
        orderList[_orderNumber].status == 102;
        currentOrder.status = 1;
    }
    
    function purchaseFailed(uint _orderNumber) public{
        require(orderExist(_orderNumber),"Order does not exist");
        require(orderList[_orderNumber].status == 101,"Order Not Active");
        Order memory currentOrder = orderList[_orderNumber];
        productContract.increaseCount(currentOrder.productID,currentOrder.count);
        currentOrder.buyer.transfer(currentOrder.amount);
        orderList[_orderNumber].status == 103;
    }
    
    function getActiveSellerOrders() public view returns (uint[] memory activeOrders) {
        uint j =0;
        for(uint i =0; i<sellerList[msg.sender].length;i++){
            if (orderList[sellerList[msg.sender][i]].status == 101){
                activeOrders[j]=(sellerList[msg.sender][i]);
                j ++;
            }
        }
    }
    
}
