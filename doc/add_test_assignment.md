# Let's test

1) Install `rspec-rails` gem by appending this gem into Gemfile:

```
group :development, :test do
  gem 'rspec-rails'
end

```

then `bundle install`

2) Next we tell rspec to generate spec folder for us:

```
rails generate rspec:install
```

You would find a new folder `spec` is created, next we need to
create following folders:

```
mkdir -p spec/models       # for model tests
mkdir -p spec/controllers  # for controller tests
mkdir -p spec/helpers      # for helpers tests
mkdir -p spec/routing      # for router tests
mkdir -p spec/features     # for acceptance/integration tests
mkdir -p spec/views        # for view tests
```

Once done, we could safely remove the Rails's default test folder
because we are going to use rspec-rails instead

```
rm -rf test
```

3) Write a new spec for our `Spree::Product#on_sale?` and `Spree::Product#on_sale=`
by creating new file `spec/models/product_spec.rb`:

```ruby
require 'spec_helper'

describe Spree::Product do
  describe '#on_sale?' do
    it 'returns master variant #on_sale' do

    end
  end

  describe '#on_sale=' do
    it 'sets master variant #on_sale' do

    end
  end
end
```

Above is a skeleton how a spec should be, now let's fill the meat in our test

4) Start with `#on_sale?`, we need to prepare our data to test, we need to create
a product. We know that when creating new product, Spree would automatically create
a master variant for us.

```ruby
  describe '#on_sale?' do
    before do
      @shipping_category = Spree::ShippingCategory.create!(name: 'Default shipping')
      @product = Spree::Product.create!(name: 'Tee Shirt', price: 5.0, shipping_category: @shipping_category)
    end

    it 'returns master variant #on_sale' do

    end
  end
```

Now, you might be wondering why I create @shipping_category, it is because Product requires
a shipping_category.

Next we write our test logic:

* Set #on_sale master variant of the product and check if #on_sale? returns what we set for our master variant

```ruby
  describe '#on_sale?' do
    before do
      @shipping_category = Spree::ShippingCategory.create!(name: 'Default shipping')
      @product = Spree::Product.new(name: 'Tee Shirt', price: 5.0)
      @product.shipping_category = @shipping_category
      @product.save!
    end

    it 'returns master variant #on_sale' do
      @product.master.on_sale = true
      expect(@product.on_sale?).to be_true

      @product.master.on_sale = false
      expect(@product.on_sale?).to be_false
    end
  end
```

Before running our spec, we need to prepare our test DB first:

```
RAILS_ENV=test rake db:drop db:create db:schema:load
```

then run our spec with:

```
rspec spec/models/product_spec.rb
````

and if nothing goes wrong, you should see:

```
.

Finished in 0.13604 seconds
1 example, 0 failures

Randomized with seed 24451
```

5) Now you might ask, can we refactor our test? The answer if yes.

The first thing we will do is to refactor:

```
expect(@product.on_sale?).to be_true
```

You can refactor it to:

```
expect(@product).to be_on_sale
```

and for:

```
expect(@product.on_sale?).to be_false
```

we refactor to:

```
expect(@product).not_to be_on_sale
```

Isn't that better?, so our code would be:

```ruby
  describe '#on_sale?' do
    before do
      @shipping_category = Spree::ShippingCategory.create!(name: 'Default shipping')
      @product = Spree::Product.new(name: 'Tee Shirt', price: 5.0)
      @product.shipping_category = @shipping_category
      @product.save!
    end

    it 'returns master variant #on_sale' do
      @product.master.on_sale = true
      expect(@product).to be_on_sale

      @product.master.on_sale = false
      expect(@product).not_to be_on_sale
    end
  end
```

Well, now, there are still more room for improvements. We're going to use `context` method
to make the test for descritive:

```ruby
  describe '#on_sale?' do
    before do
      @shipping_category = Spree::ShippingCategory.create!(name: 'Default shipping')
      @product = Spree::Product.new(name: 'Tee Shirt', price: 5.0)
      @product.shipping_category = @shipping_category
      @product.save!
    end

    context 'master_variant#on_sale is true' do
      before do
        @product.master.on_sale = true
      end

      it 'returns true' do
        expect(@product).to be_on_sale
      end
    end

    context 'master_variant#on_sale is false' do
      before do
        @product.master.on_sale = false
      end

      it 'returns false' do
        expect(@product).not_to be_on_sale
      end
    end
  end
```

Looks better now right, but can we do even better?..hmm yes we can. We can refactor the
`before` block where we create product data with FactorGirl. FactoryGirl (abbr as FG) is a gem that
allow you to create shared template data. First, we need to add `factory_girl_rails` gem
 and `ffaker` gem (that FG used) into our Gemfile:

```
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
end
```

then `bundle install`

We need to edit our `spec/spec_helper.rb` and add in:


```ruby
require 'ffaker'
require 'spree/testing_support/factories'
```

The above code will load all FactoryGirl factories and make it available for our tests. Please look into the factories provided by spree with command:

```
bundle open spree_open
```

and look into `lib/testing_support/factories`

For our spec, we are interested in `lib/testing_support/factories/product_factory.rb`, open the file and learn how FactoryGirl define a factory

Let's replace our data creation code with FactoryGirl factory:

```ruby
  describe '#on_sale?' do
    before do
      @product = FactoryGirl.create(:product)
    end

```

and run our test again


```
rspec spec/models/product_spec.rb
````

and you should see:

```
..

Finished in 0.31004 seconds
2 examples, 0 failures

Randomized with seed 52405
```

6) So now, why don't you two write `#on_sale=` spec


