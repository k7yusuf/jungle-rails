require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      @user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(@user).to be_valid
    end

    it 'is not valid without a password' do
      @user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com'
      )
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'is not valid without matching password_confirmation' do
      @user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'different_password'
      )
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'is not valid without an email' do
      @user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid with a duplicate email' do
      @user1 = User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      @user2 = User.new(
        first_name: 'Jane',
        last_name: 'Smith',
        email: 'TEST@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(@user2).not_to be_valid
      expect(@user2.errors.full_messages).to include("Email has already been taken")
    end

    it 'is not valid without a first name' do
      @user = User.new(
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid without a last name' do
      @user = User.new(
        first_name: 'John',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'is not valid with a password of less than 8 characters' do
      @user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'short',
        password_confirmation: 'short'
      )
      expect(@user).not_to be_valid
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    before do
      @user = User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'authenticates successfully with valid credentials' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'authenticates successfully with email having leading/trailing spaces' do
      authenticated_user = User.authenticate_with_credentials(' test@example.com ', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'authenticates successfully with email having different case' do
      authenticated_user = User.authenticate_with_credentials('tEsT@example.com', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'does not authenticate with incorrect password' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'wrong_password')
      expect(authenticated_user).to be_nil
    end

    it 'does not authenticate with non-existent email' do
      authenticated_user = User.authenticate_with_credentials('nonexistent@example.com', 'password')
      expect(authenticated_user).to be_nil
    end
  end
end
