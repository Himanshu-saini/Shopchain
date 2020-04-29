const User = artifacts.require("AddUser");
const Product = artifacts.require("AddProduct");
// const Shopping = artifacts.require("Shopping");

module.exports = function(deployer) {
    deployer.deploy(User);
    deployer.deploy(Product);
    // deployer.deploy(Shopping);
};
