require "spec_helper"

RSpec.describe RailsPaymentSandbox::Gateway do
  let(:amount) { 1000 }
  let(:currency) { "INR" }
  let(:gateways) { %i[stripe razorpay paypal paytm gpay apple_pay phonepe amazon_pay cashfree] }
  let(:statuses) { %i[success failed pending] }

  describe "initialization" do
    it "raises an error for unsupported gateway" do
      expect {
        described_class.new(gateway: :unknown, amount: amount)
      }.to raise_error(ArgumentError, "Unsupported gateway")
    end

    it "sets provided amount and currency correctly" do
      gateways.each do |gw|
        gateway = described_class.new(gateway: gw, amount: amount, currency: currency)
        expect(gateway.gateway).to eq(gw)
        expect(gateway.amount).to eq(amount)
        expect(gateway.currency).to eq(currency)
      end
    end

    it "defaults status to a valid random status if not provided" do
      gateways.each do |gw|
        gateway = described_class.new(gateway: gw, amount: amount)
        expect(statuses).to include(gateway.status)
      end
    end

    it "sets status if provided" do
      gateways.each do |gw|
        statuses.each do |st|
          gateway = described_class.new(gateway: gw, amount: amount, status: st)
          expect(gateway.status).to eq(st)
        end
      end
    end

    it "auto-generates an order_id if not provided" do
      gateway = described_class.new(gateway: :stripe, amount: amount)
      expect(gateway.order_id).to match(/^ORD-\d+-\d+$/)
    end

    it "accepts a custom order_id if provided" do
      gateway = described_class.new(gateway: :stripe, amount: amount, order_id: "ORD-12345")
      expect(gateway.order_id).to eq("ORD-12345")
    end
  end

  describe "#process" do
    it "returns a hash with correct keys and values" do
      gateways.each do |gw|
        statuses.each do |st|
          gateway = described_class.new(gateway: gw, amount: amount, status: st)
          result = gateway.process

          expect(result).to be_a(Hash)
          expect(result[:gateway]).to eq(gw)
          expect(result[:order_id]).to eq(gateway.order_id)
          expect(result[:amount]).to eq(amount)
          expect(result[:currency]).to eq(currency)
          expect(result[:status]).to eq(st)
          expect(result[:transaction_id]).to eq(gateway.transaction_id)
          expect(result[:message]).to include(gw.to_s.capitalize)
        end
      end
    end
  end

  describe "transaction_id" do
    it "generates unique transaction IDs for multiple instances" do
      t1 = described_class.new(gateway: :stripe, amount: amount)
      sleep 1 # ensure timestamp difference
      t2 = described_class.new(gateway: :stripe, amount: amount)
      expect(t1.transaction_id).not_to eq(t2.transaction_id)
    end

    it "transaction_id format matches gateway initials, timestamp, and random number" do
      gateways.each do |gw|
        gateway = described_class.new(gateway: gw, amount: amount)
        expect(gateway.transaction_id).to match(/^#{gw.to_s[0..2].upcase}-\d+-\d+$/)
      end
    end
  end

  describe "all gateways and statuses coverage" do
    it "processes all gateways with all possible statuses correctly" do
      gateways.each do |gw|
        statuses.each do |st|
          gateway = described_class.new(gateway: gw, amount: amount, status: st)
          result = gateway.process
          expect(result[:gateway]).to eq(gw)
          expect(result[:status]).to eq(st)
          expect(result[:order_id]).to match(/^ORD-|ORD-/)
          expect(result[:message]).to be_a(String)
        end
      end
    end
  end
end
