module RailsPaymentSandbox
  class Gateway
    GATEWAYS = %i[stripe razorpay paypal].freeze
    STATUSES = %i[success failed pending].freeze

    attr_reader :gateway, :amount, :currency, :status, :transaction_id

    def initialize(gateway:, amount:, currency: "INR", status: nil)
      raise ArgumentError, "Unsupported gateway" unless GATEWAYS.include?(gateway.to_sym)

      @gateway = gateway
      @amount = amount
      @currency = currency
      @status = status || STATUSES.sample
      @transaction_id = generate_transaction_id
    end

    def process
      {
        gateway: gateway,
        transaction_id: transaction_id,
        amount: amount,
        currency: currency,
        status: status,
        message: message
      }
    end

    private

    def generate_transaction_id
      "#{gateway[0..2].upcase}-#{Time.now.to_i}-#{rand(1000..9999)}"
    end

    def message
      case status
      when :success
        "Payment completed successfully"
      when :failed
        "Payment failed"
      when :pending
        "Payment is pending"
      end
    end
  end
end
