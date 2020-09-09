const Product = artifacts.require('./AddProduct.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Product', ([seller,buyer]) => {
  let product

  before(async () => {
    product = await Product.deployed()
  })

  describe('Product Contract Deployment', async () => {
    it('Deployment Successfully', async () => {
      const address = await product.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })
  })

  describe('Product Functions', async () => {
    let result

    before(async () => {
      result = await product.createProduct('Electron4x', web3.utils.toWei('1', 'Ether'), 10, 'Electronics','Sword Corp.','It is Mobile',{from: seller})
    })

    it('creates new Product', async () => {
      // SUCCESS
      const event = result.logs[0].args
      assert.equal(event.name, 'Electron4x', 'name is correct')
      assert.equal(event.seller, seller, 'account is correct')
      assert.equal(event.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
      assert.equal(event.count, 10, 'Count is correct')
      assert.equal(event.category, 'Electronics', 'Catergory is correct')
      assert.equal(event.active, true, 'Active state is correct')

      // FAILURE
      await await product.createProduct('', web3.utils.toWei('1', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product').should.be.rejected;
      await await product.createProduct('Electron4x', web3.utils.toWei('0', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product').should.be.rejected;

    })

    it('Get Product', async () => {
      const product1 = await product.productList(1)
      //SUCCESS
      assert.equal(product1.productID, 1, 'ID is correct')
      assert.equal(product1.name, 'Electron4x', 'name is correct')
      assert.equal(product1.seller, seller, 'account is correct')
      assert.equal(product1.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
      assert.equal(product1.count, 10, 'Count is correct')
      assert.equal(product1.category, 'Electronics', 'Catergory is correct')
      assert.equal(product1.active, true, 'Active state is correct')
    })

    it('Change Product price',async () => {
        //SUCCESS
        await product.changePrice(1,web3.utils.toWei('5', 'Ether'))
        const product1 = await product.productList(1)
        assert.equal(product1.price,web3.utils.toWei('5', 'Ether'),"Price changed")
        
        //FAILURE
        await await product.changePrice(10,web3.utils.toWei('2','Ether')).should.be.rejected
        await await product.changePrice(1,web3.utils.toWei('0','Ether')).should.be.rejected
        await await product.changePrice(1,web3.utils.toWei('0','Ether'),{from: buyer}).should.be.rejected
    })

    it('Change Product Count',async () => {
        //SUCCESS
        await product.changeCount(1,5)
        const prod = await product.productList(1)
        assert.equal(prod.count,5,"Product Count changed")
        //FAILURE
        await product.changePrice(10,5).should.be.rejected
        await product.changePrice(1,5,{from: buyer}).should.be.rejected
    })

    it('Decrease Product Count',async () => {
        //SUCCESS
        let product1 = await product.productList(1)
        initialCount = product1.count
        await product.decreaseCount(1,2)
        product1 = await product.productList(1)
        finalCount = product1.count
        assert.equal(initialCount - finalCount,2,"Product Count Decreased")
        //FAILURE
        await product.decreaseCount(10,2).should.be.rejected
        await product.decreaseCount(1,5).should.be.rejected
    })
    it('Increase Product Count',async () => {
        //SUCCESS
        let product1 = await product.productList(1)
        initialCount = product1.count
        await product.increaseCount(1,3)
        product1 = await product.productList(1)
        finalCount = product1.count
        assert.equal(finalCount - initialCount,3,"Product Count Inscreased")
        //FAILURE
        await product.increaseCount(2,3).should.be.rejected
    })
    it('Get seller Producct list', async () => {
        let product_list = await product.getSellerProducts();
        assert.equal(product_list.length,1,"Seller Products list returned")
    })

  })
})
