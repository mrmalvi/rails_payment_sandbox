module RailsPaymentSandbox
  class Gateway
    # Supported gateways
    GATEWAYS = %i[
      stripe razorpay paypal paytm gpay apple_pay phonepe amazon_pay cashfree
    ].freeze

    STATUSES = %i[success failed pending].freeze

    attr_reader :gateway, :amount, :currency, :status, :transaction_id, :order_id

    def initialize(gateway:, amount:, currency: "INR", status: nil, order_id: nil)
      raise ArgumentError, "Unsupported gateway" unless GATEWAYS.include?(gateway.to_sym)

      @gateway = gateway.to_sym
      @amount = amount
      @currency = currency
      @status = status || STATUSES.sample
      @transaction_id = generate_transaction_id
      @order_id = order_id || generate_order_id
    end

    def process
      {
        gateway: gateway,
        order_id: order_id,
        transaction_id: transaction_id,
        amount: amount,
        currency: currency,
        status: status,
        message: message
      }
    end

    private

    def generate_transaction_id
      "#{gateway.to_s[0..2].upcase}-#{Time.now.to_i}-#{rand(1000..9999)}"
    end

    def generate_order_id
      "ORD-#{Time.now.to_i}-#{rand(10000..99999)}"
    end

    def message
      case status
      when :success
        "Payment completed successfully via #{gateway.to_s.capitalize}"
      when :failed
        "Payment failed on #{gateway.to_s.capitalize}"
      when :pending
        "Payment is pending on #{gateway.to_s.capitalize}"
      end
    end
  end
end
