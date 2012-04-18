require 'spec_helper'

describe Order, :model => :order do
  let!(:status) { Fabricate(:status) }
  let(:order) { Fabricate(:order) }
  let(:cancelled) { StoreEngine::Status::CANCELLED }
  let(:shipped) { StoreEngine::Status::SHIPPED }
  let(:returned) { StoreEngine::Status::RETURNED }
  let(:paid) { StoreEngine::Status::PAID }

  context "#update_status" do
    it "changes pending status to cancelled" do
      order.should_receive(:status).and_return(status)
      cancelled_status = Fabricate(:status, :name => cancelled)

      Status.stub(:find_by_name).with(cancelled).and_return(cancelled_status)
      order.should_receive(:update_attributes).with(:status => cancelled_status)

      order.update_status
    end

    it "changes shipped to returned" do
      shipped_status = Fabricate(:status, :name => shipped)
      order.should_receive(:status).and_return(shipped_status)

      returned_status = Fabricate(:status, :name => returned)
      Status.stub(:find_by_name).with(returned).and_return(returned_status)

      order.should_receive(:update_attributes).with(:status => returned_status)
      order.update_status
    end

    it "changes paid to shipped" do
      paid_status = Fabricate(:status, :name => paid)
      order.should_receive(:status).and_return(paid_status)

      shipped_status = Fabricate(:status, :name => shipped)
      Status.stub(:find_by_name).with(shipped).and_return(shipped_status)

      order.should_receive(:update_attributes).with(:status => shipped_status)
      order.update_status
    end
  end
end
