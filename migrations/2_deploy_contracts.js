const Product = artifacts.require("AddProduct");
const Shopping = artifacts.require("Shopping");

module.exports = function(deployer) {
    deployer.deploy(Product).then(function(Product){
        product_address = Product.address;
        deployer.deploy(Shopping,product_address);
    })
};
