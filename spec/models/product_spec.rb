require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      @category = Category.create(name: 'Electronics')
      @product = Product.new(name: 'Gadget', price_cents: 1000, quantity: 5, category: @category)
      expect(@product).to be_valid
    end

    it 'is not valid without a name' do
      @category = Category.create(name: 'Electronics')
      @product = Product.new(price_cents: 1000, quantity: 5, category: @category)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages).to include("Name can't be blank")
    end

    it 'is not valid without a price' do
      @category = Category.create(name: 'Electronics')
      @product = Product.new(name: 'Gadget', quantity: 5, category: @category)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages).to include("Price can't be blank")
    end

    it 'is not valid without a quantity' do
      @category = Category.create(name: 'Electronics')
      @product = Product.new(name: 'Gadget', price_cents: 1000, category: @category)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages).to include("Quantity can't be blank")
    end

    it 'is not valid without a category' do
      @product = Product.new(name: 'Gadget', price_cents: 1000, quantity: 5)
      expect(@product).not_to be_valid
      expect(@product.errors.full_messages).to include("Category can't be blank")
    end
  end
end
