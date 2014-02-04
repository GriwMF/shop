require 'spec_helper'

describe Order do
  let(:order) { FactoryGirl.create :order }
  
  it "has many books through order_items" do
    expect(order).to have_many(:books).through(:order_items)
  end
  
  it "belongs to customer" do
    expect(order).to belong_to(:customer)
  end

  it "billing address belongs to address" do
    expect(order).to belong_to(:bill_addr).class_name("Address")
  end  
  
  it "shipping address belongs to address" do
    expect(order).to belong_to(:ship_addr).class_name("Address")
  end  

  it "belongs to credit card" do
    expect(order).to belong_to(:credit_card)
  end    
  
  it "has many order items, dependent destroy" do
    expect(order).to have_many(:order_items).dependent(:destroy)
  end    
  
  its "state are in %w(processing selecting shipped)" do
    expect(order).to ensure_inclusion_of(:state).in_array(%w(processing selecting shipped cancelled))
  end
  
  describe "order_items methods" do
    let(:order) { FactoryGirl.create(:order_with_book_price_5_and_quantity_3) }
    let(:book) { FactoryGirl.create(:book, price: 7, in_stock: 50) }

    context "#refresh_prices" do
      before { order.refresh_prices }
      
      it "updates total_price" do
        expect(Order.find(order).total_price).to eq(45)
      end
      
      it "updates prices in order_items" do
        expect(order.order_items[0].price).to eq(5)
        expect(order.order_items[1].price).to eq(5)
        expect(order.order_items[2].price).to eq(5)
      end
    end
    
    context "#add_item" do
      
      it "add one item" do
        expect { order.add_item(book) }.to change { order.order_items.count}.by(1)
      end
      
      it "saves proper quantity" do
        item = order.add_item(book, quantity: 21)
        expect(OrderItem.find(item).quantity).to eq(21)
      end
      
      it "asociate item with order" do
        item = order.add_item(book)
        expect(OrderItem.find(item).order).to eq(order)
      end
      
      it "increses quantity if order exist" do
        order.add_item(book)
        expect { order.add_item(book, quantity: 5) }.to change { order.order_items.find_by(book_id: book.id).quantity }.by(5)
      end
    end
    
    context "#refresh_in_stock!" do
      it "change in_stock for purchaced books" do
        order.refresh_in_stock!
        expect(order.order_items[0].book.in_stock).to eq(0)
        expect(order.order_items[1].book.in_stock).to eq(0)
        expect(order.order_items[2].book.in_stock).to eq(0)
      end
      
      it "raise error if no book in stock and rollback changes" do
        item = order.add_item(book, quantity: 4)
        book.in_stock = 3
        book.save
        expect { order.refresh_in_stock! }.to raise_error(ActiveRecord::RecordInvalid)    
        expect(item.book.in_stock).to eq(3)   
      end
    end
    
    context "#complete_order" do
      before do
        allow(order).to receive(:refresh_in_stock!)
        allow(order).to receive(:refresh_prices)
      end
      
      it "calls #refresh_prices!" do
        expect(order).to receive(:refresh_prices)
        order.complete_order!
      end
      
      it "calls #refresh_in_stock!" do
        expect(order).to receive(:refresh_in_stock!)
        order.complete_order!
      end

      it "change completed_at to now" do
        expect { order.complete_order! }.to change { order.completed_at }
      end
    end
  end
  
  describe "states" do
    before do
      allow(order).to receive(:complete_order!)
    end
    
    context "check_out" do
      it "changes state from selecting to processing" do
        expect(order.state).to eq("selecting")
        expect { order.check_out! }.to change { order.state }.to("processing")
      end
      
      it "calls #complete_order!" do
        expect(order).to receive(:complete_order!)
        order.check_out!
      end
    end
    
    context "ship" do
      it "changes state from processing to shipped" do
        order.check_out!
        expect { order.ship }.to change { order.state }.to("shipped")
      end
    end
    
    context "cancel" do
      it "changes state from processing to cancelled" do
        order.check_out!
        expect { order.cancel }.to change { order.state }.to("cancelled")
      end
    end
  end
end