const Product = artifacts.require("Product");
const User = artifacts.require("User");
// const Shopping = artifacts.require("Shooping");

module.exports = function(deployer) {
    deployer.deploy(User);
    deployer.deploy(Product);
    // deployer.deploy(Shopping);
};
