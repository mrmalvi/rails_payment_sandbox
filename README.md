# RailsPaymentSandbox

[![Gem Version](https://badge.fury.io/rb/rails_payment_sandbox.svg)](https://badge.fury.io/rb/rails_payment_sandbox)

RailsPaymentSandbox simulates multiple payment gateways locally with fake transactions for **development and testing** purposes.
It saves developers from needing real API keys, sandbox accounts, or actual money movement when testing payment flows.

---

## Features

- 🔌 Supports multiple gateways:
  - `Stripe`
  - `Razorpay`
  - `PayPal`
  - `Paytm`
  - `Google Pay (GPay)`
  - `Apple Pay`
  - `PhonePe`
  - `Amazon Pay`
  - `Cashfree`
- 🎲 Random or controlled statuses: `success`, `failed`, `pending`
- 🧾 Generates fake `transaction_id` and `order_id`
- 🛠 No real API calls, safe for local and CI environments
- 📊 Easy integration with RSpec or Rails apps

---

## Installation

Add this line to your Gemfile:

```ruby
gem 'payment_sandbox_rails'
```

And then run:

```bash
bundle install
```

Or install it yourself:

```bash
gem install payment_sandbox_rails
```

---

## Usage

```ruby
require "rails_payment_sandbox"

# Create a new sandbox payment (random status)
payment = RailsPaymentSandbox::Gateway.new(
  gateway: :stripe,
  amount: 1000,          # amount in smallest unit (e.g. paise for INR)
  currency: "INR"
)

result = payment.process

puts result
# {
#   gateway: :stripe,
#   order_id: "ORD-1696212345-4821",
#   transaction_id: "STR-1696212345-4821",
#   amount: 1000,
#   currency: "INR",
#   status: :success,
#   message: "Stripe payment completed successfully"
# }
```

---

### Force a Specific Status

```ruby
payment = RailsPaymentSandbox::Gateway.new(
  gateway: :razorpay,
  amount: 500,
  status: :failed
)

puts payment.process
# => { gateway: :razorpay, status: :failed, message: "Razorpay payment failed", ... }
```

---

### Provide a Custom Order ID

```ruby
payment = RailsPaymentSandbox::Gateway.new(
  gateway: :paypal,
  amount: 1500,
  order_id: "ORD-TEST-12345"
)

puts payment.process[:order_id]
# => "ORD-TEST-12345"
```

---

## Development

After checking out the repo, run:

```bash
bin/setup
rake spec
```

You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine:

```bash
bundle exec rake install
```

To release a new version:
1. Update the version number in `lib/rails_payment_sandbox/version.rb`.
2. Run `bundle exec rake release` (this will create a git tag, push commits/tags, and publish to [rubygems.org](https://rubygems.org)).

---

## Contributing

Bug reports and pull requests are welcome on GitHub:
👉 https://github.com/[USERNAME]/rails_payment_sandbox

---

## License

This project is licensed under the [MIT License](LICENSE).
