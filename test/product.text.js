const Product = artifacts.require('./Product.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Product', (account) => {
  let product

  before(async () => {
    product = await Product.deployed()
  })

  describe('deployment', async () => {
    it('deployment successfully', async () => {
      const address = await product.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })
  })

  describe('user', async () => {
    let result

    before(async () => {
      result = await product.createProduct('Electron4x', web3.utils.toWei('1', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product')
    })

    it('creates new Product', async () => {
      // SUCCESS
      const event = result.logs[0].args
      assert.equal(event.name, 'Electron4x', 'name is correct')
      assert.equal(event.seller, account, 'account is correct')
      assert.equal(event.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
      assert.equal(event.count, 10, 'Count is correct')
      assert.equal(event.category, 'Electronics', 'Catergory is correct')
      assert.equal(event.active, true, 'Active state is correct')

      // FAILURE
      await await user.createProduct('', web3.utils.toWei('1', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product').should.be.rejected;
      await await user.createProduct('Electron4x', web3.utils.toWei('0', 'Ether'), 10, 'Electronics','Sword Corp.','It is our main Product').should.be.rejected;

    })

    it('Get Product', async () => {
      const prod = await Product.productlist(1)
      assert.equal(prod.name, 'Electron4x', 'name is correct')
      assert.equal(prod.seller, account, 'account is correct')
      assert.equal(prod.price, web3.utils.toWei('1', 'Ether'), 'Price is correct')
      assert.equal(prod.count, 10, 'Count is correct')
      assert.equal(prod.category, 'Electronics', 'Catergory is correct')
      assert.equal(prod.active, true, 'Active state is correct')
    })
  })
})
