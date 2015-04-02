require 'spec_helper'

describe Spree::Order do
  let(:ordered_on) { Spree::GarbageCleaner::Config.cleanup_days_interval }

  context 'class methods' do
    before do
      @order_one = create(:order, created_at: (ordered_on + rand(10)).days.ago,
                                                  completed_at: nil)
      @order_two = create(:order, created_at: (ordered_on + rand(10)).days.ago,
                                                  completed_at: nil)
      @order_three = create(:order)
    end

    it 'has a garbage finder method' do
      expect(Spree::Order.garbage).to eq [@order_one, @order_two]
    end

    it 'has a method to destroy garbage' do
      expect(Spree::Order.destroy_garbage).to eq [@order_one, @order_two]
      expect(Spree::Order.garbage.count).to eq 0
      expect(Spree::Order.all).to include(@order_three)
    end
  end

  context 'instance methods' do
    it 'has a method that tells if order is garbage' do
      order = build(:order)
      expect(order).to respond_to(:garbage?)
    end

    it 'is garbage if not completed and past cleanup_days_interval' do
      order = build(:order, created_at: ordered_on.days.ago, completed_at: nil)
      expect(order.garbage?).to be_truthy
    end

    it 'is not garbage if not completed and not past cleanup_days_interval' do
      order = build(:order, created_at: (ordered_on - 1).days.ago,
                            completed_at: nil)
      expect(order.garbage?).to be_falsey
    end

    it 'is not garbage if completed and past cleanup_days_interval' do
      order = build(:order, created_at: ordered_on.days.ago,
                            completed_at: Time.now)
      expect(order.garbage?).to be_falsey
    end

    it 'is not garbage if completed and not past cleanup_days_interval' do
      order = build(:order, completed_at: Time.now)
      expect(order.garbage?).to be_falsey
    end
  end

  context 'associated objects' do
    let(:order) { create(:order, created_at: (ordered_on + rand(10)).days.ago,
                                 completed_at: nil)
    }
    let(:payment) { create :payment }
    let(:adjustment) { create :adjustment, order: order }
    let(:shipment) { create :shipment }
    let(:line_item) { create :line_item, order: order  }

    subject { Spree::Order.destroy_garbage }

    it 'removes line_items' do
      order.line_items << line_item
      subject
      expect(Spree::LineItem.all).to_not include(order.line_items)
    end
    it 'removes adjustments' do
      subject
      expect(Spree::Adjustment.all).to_not include(order.adjustments)
    end
    it 'removes payments' do
      order.payments << payment
      subject
      expect(Spree::Payment.all).to_not include(order.payments)
    end
    it 'removes shipments' do
      order.shipments << shipment
      subject
      expect(Spree::Shipment.all).to_not include(order.shipments)
    end
  end
end
