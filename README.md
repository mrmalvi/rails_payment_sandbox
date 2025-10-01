# RailsPaymentSandbox

RailsPaymentSandbox simulates multiple payment gateways locally with fake transactions for testing purposes.

## Features

- Supports `Stripe`, `Razorpay`, and `PayPal`
- Generates fake transactions with random status: `success`, `failed`, `pending`
- No real payments are made
- Easy integration in development and tests

---

## Installation

Add this to your Gemfile:

```ruby
gem 'rails_payment_sandbox'
```

Then run:

```bash
bundle install
```

---

## Usage

### Basic Example

```ruby
require "rails_payment_sandbox"

# Optional configuration
RailsPaymentSandbox.configure do |config|
  config[:default_currency] = "INR"
end

# Create a fake Stripe transaction
transaction = RailsPaymentSandbox::Gateway.new(
  gateway: :stripe,
  amount: 5000
)

puts transaction.process
```

**Sample Output:**

```json
{
  "gateway": "stripe",
  "transaction_id": "STR-1696160001-2345",
  "amount": 5000,
  "currency": "INR",
  "status": "success",
  "message": "Payment completed successfully"
}
```

---

### Simulate Multiple Gateways

```ruby
gateways = %i[stripe razorpay paypal]
amount = 5000

gateways.each do |gw|
  tx = RailsPaymentSandbox::Gateway.new(gateway: gw, amount: amount)
  result = tx.process

  puts "Gateway: #{result[:gateway].to_s.capitalize}"
  puts "Transaction ID: #{result[:transaction_id]}"
  puts "Amount: #{result[:amount]} #{result[:currency]}"
  puts "Status: #{result[:status]}"
  puts "Message: #{result[:message]}"
  puts "-" * 50
end
```

---

### Simulate Multiple Transactions

```ruby
transactions = []

10.times do
  gateways.each do |gw|
    tx = RailsPaymentSandbox::Gateway.new(
      gateway: gw,
      amount: rand(100..10000),
      status: [:success, :failed, :pending].sample
    )
    transactions << tx.process
  end
end

puts transactions
```

- This simulates **30 transactions** (10 × 3 gateways) with random amounts and statuses.
- Ideal for testing dashboards, reporting, or automated flows.

---

## Development

After checking out the repo:

```bash
bin/setup
```

Run the tests:

```bash
bundle exec rspec
```

Open an interactive console:

```bash
bin/console
```

Install the gem locally:

```bash
bundle exec rake install
```

Release a new version:

```bash
bundle exec rake release
```

This will:
- Update the version number in `version.rb`
- Build the `.gem` file
- Push git commits and tag
- Push the gem to [rubygems.org](https://rubygems.org)

---

## Contributing

Bug reports and pull requests are welcome on GitHub at:

[https://github.com/mrmalvi/rails-payment-sandbox](https://github.com/mrmalvi/rails_payment_sandbox)

Please follow standard GitHub pull request workflow.

---

## License

MIT License
