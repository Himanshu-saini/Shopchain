const User = artifacts.require('./AddUser.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('User', ([account]) => {
  let user

  before(async () => {
    user = await User.deployed()
  })

  describe('deployment', async () => {
    it('deployment successfully', async () => {
      const address = await user.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })
  })

  describe('user', async () => {
    let result

    before(async () => {
      result = await user.createUser('Himanshu', '111,Sector 11,Gurgaon','9899880773','himanshu@gmail.com','buyer')
    })

    it('creates new user', async () => {
      // SUCCESS
      const event = result.logs[0].args
      assert.equal(event.name, 'Himanshu', 'name is correct')
      assert.equal(event.account, account, 'account is correct')
      assert.equal(event.location, '111,Sector 11,Gurgaon', 'location is correct')
      assert.equal(event.phone, '9899880773', 'phone number is correct')
      assert.equal(event.email, 'himanshu@gmail.com', 'email is correct')
      assert.equal(event.accountType, 'buyer', 'Account Type is correct')

      // FAILURE
      await await user.createUser('', '111,Sector 11,Gurgaon','9899880773','himanshu@gmail.com','buyer').should.be.rejected;
      await await user.createUser('Himanshu', '','9899880773','himanshu@gmail.com','buyer').should.be.rejected;
      await await user.createUser('Himanshu', '111,Sector 11,Gurgaon','989','himanshu@gmail.com','buyer').should.be.rejected;
      await await user.createUser('Himanshu', '111,Sector 11,Gurgaon','9899880773','','buyer').should.be.rejected;
    })

    it('Get User', async () => {
      const person = await user.userAccount(account)
      assert.equal(person.name, 'Himanshu', 'name is correct')
      assert.equal(person.account, account, 'account is correct')
      assert.equal(person.location, '111,Sector 11,Gurgaon', 'location is correct')
      assert.equal(person.phone, '9899880773', 'phone number is correct')
      assert.equal(person.email, 'himanshu@gmail.com', 'email is correct')
      assert.equal(person.accountType, 'buyer', 'Account Type is correct')
    })
  })
})
