const Product = artifacts.require('./AddProduct.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Product', ([account1,account2]) => {
  let product

  before(async () => {
    product = await Product.deployed()
  })

  describe('Product deployment', async () => {
    it('deployment successfully', async () => {
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
      result = await product.createProduct('Electron4x', web3.utils.toWei('1', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product')
    })

    it('creates new Product', async () => {
      // SUCCESS
      const event = result.logs[0].args
      assert.equal(event.name, 'Electron4x', 'name is correct')
      assert.equal(event.seller, account1, 'account is correct')
      assert.equal(event.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
      assert.equal(event.count, 10, 'Count is correct')
      assert.equal(event.category, 'Electronics', 'Catergory is correct')
      assert.equal(event.active, true, 'Active state is correct')

      // FAILURE
      await await product.createProduct('', web3.utils.toWei('1', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product').should.be.rejected;
      await await product.createProduct('Electron4x', web3.utils.toWei('0', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product').should.be.rejected;

    })

    it('Get Product', async () => {
      const prod = await product.productList(1)
      //SUCCESS
      assert.equal(prod.id, 1, 'ID is correct')
      assert.equal(prod.name, 'Electron4x', 'name is correct')
      assert.equal(prod.seller, account1, 'account is correct')
      assert.equal(prod.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
      assert.equal(prod.count, 10, 'Count is correct')
      assert.equal(prod.category, 'Electronics', 'Catergory is correct')
      assert.equal(prod.active, true, 'Active state is correct')
    })

    it('Change Product price',async () => {
        //SUCCESS
        await product.changePrice(1,web3.utils.toWei('5', 'Ether'))
        const prod = await product.productList(1)
        assert.equal(prod.price,web3.utils.toWei('5', 'Ether'),"Price changed")
        
        //FAILURE
        await await product.changePrice(10,web3.utils.toWei('2','Ether')).should.be.rejected
        await await product.changePrice(1,web3.utils.toWei('0','Ether')).should.be.rejected
        await await product.changePrice(1,web3.utils.toWei('0','Ether'),{from: account2}).should.be.rejected
    })

    it('Change Product Count',async () => {
        //SUCCESS
        await product.changeCount(1,5)
        const prod = await product.productList(1)
        assert.equal(prod.count,5,"Product Count changed")
        //FAILURE
        await product.changePrice(10,5).should.be.rejected
        await product.changePrice(1,5,{from: account2}).should.be.rejected
    })

    it('Decrease Product Count',async () => {
        //SUCCESS
        let prod = await product.productList(1)
        initialCount = prod.count
        await product.decreaseCount(1,2)
        prod = await product.productList(1)
        finalCount = prod.count
        assert.equal(initialCount - finalCount,2,"Product Count Decreased")
        //FAILURE
        await product.decreaseCount(10,2).should.be.rejected
        await product.decreaseCount(1,5).should.be.rejected
    })
    it('Increase Product Count',async () => {
        //SUCCESS
        let prod = await product.productList(1)
        initialCount = prod.count
        await product.increaseCount(1,3)
        prod = await product.productList(1)
        finalCount = prod.count
        assert.equal(finalCount - initialCount,3,"Product Count Decreased")
        //FAILURE
        await product.increaseCount(2,3).should.be.rejected
    })

  })
})
