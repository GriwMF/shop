require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe CreditCardsController do

  include Devise::TestHelpers
  
  let(:customer) { FactoryGirl.create :customer }
  # This should return the minimal set of attributes required to create a valid
  # CreditCard. As you add validations to CreditCard, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "firstname" => "MyString", "lastname" => "MyString",
                             "number" => "1234" * 4, "cvv" => "123",
                             "expiration_month" => "12", "expiration_year" => Time.now.year + 1 ,
                             "customer_id" => customer.id} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CreditCardsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:ability) { Object.new.extend(CanCan::Ability) }
  
  before do
    sign_in customer
  end
  
  describe "GET index" do
    it "assigns all credit_cards as @credit_cards" do
      credit_card = CreditCard.create! valid_attributes
      get :index, {}, valid_session
      assigns(:credit_cards).should eq([credit_card])
    end

    it 'redirect to root if havent read ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :read, CreditCard
      get :index
      response.should redirect_to(root_url)
    end
  end

  describe "GET show" do
    it "assigns the requested credit_card as @credit_card" do
      credit_card = CreditCard.create! valid_attributes
      get :show, {:id => credit_card.to_param}, valid_session
      assigns(:credit_card).should eq(credit_card)
    end

    it 'redirect to root if havent read ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :read, CreditCard
      get :show, {id: '1'}
      response.should redirect_to(root_url)
    end
  end

  describe "GET new" do
    it "assigns a new credit_card as @credit_card" do
      get :new, {}, valid_session
      assigns(:credit_card).should be_a_new(CreditCard)
    end

    it 'redirect to root if havent create ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :create, CreditCard
      get :new
      response.should redirect_to(root_url)
    end
  end

  describe "GET edit" do
    it "assigns the requested credit_card as @credit_card" do
      credit_card = CreditCard.create! valid_attributes
      get :edit, {:id => credit_card.to_param}, valid_session
      assigns(:credit_card).should eq(credit_card)
    end

    it 'redirect to root if havent update ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :update, CreditCard
      get :edit, {id: '1'}
      response.should redirect_to(root_url)
    end
  end

  describe "POST create" do
    it 'redirect to root if havent create ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :create, CreditCard
      post :create
      response.should redirect_to(root_url)
    end

    describe "with valid params" do
      it "creates a new CreditCard" do
        expect {
          post :create, {:credit_card => valid_attributes}, valid_session
        }.to change(CreditCard, :count).by(1)
      end

      it "assigns a newly created credit_card as @credit_card" do
        post :create, {:credit_card => valid_attributes}, valid_session
        assigns(:credit_card).should be_a(CreditCard)
        assigns(:credit_card).should be_persisted
      end

      it "redirects to the created credit_card" do
        post :create, {:credit_card => valid_attributes}, valid_session
        response.should redirect_to(CreditCard.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved credit_card as @credit_card" do
        # Trigger the behavior that occurs when invalid params are submitted
        CreditCard.any_instance.stub(:save).and_return(false)
        post :create, {:credit_card => { "firstname" => "invalid value" }}, valid_session
        assigns(:credit_card).should be_a_new(CreditCard)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        CreditCard.any_instance.stub(:save).and_return(false)
        post :create, {:credit_card => { "firstname" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    it 'redirect to root if havent update ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :update, CreditCard
      put :update, {id: '1'}
      response.should redirect_to(root_url)
    end

    describe "with valid params" do
      it "updates the requested credit_card" do
        credit_card = CreditCard.create! valid_attributes
        # Assuming there are no other credit_cards in the database, this
        # specifies that the CreditCard created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        CreditCard.any_instance.should_receive(:update).with({ "firstname" => "MyString" })
        put :update, {:id => credit_card.to_param, :credit_card => { "firstname" => "MyString" }}, valid_session
      end

      it "assigns the requested credit_card as @credit_card" do
        credit_card = CreditCard.create! valid_attributes
        put :update, {:id => credit_card.to_param, :credit_card => valid_attributes}, valid_session
        assigns(:credit_card).should eq(credit_card)
      end

      it "redirects to the credit_card" do
        credit_card = CreditCard.create! valid_attributes
        put :update, {:id => credit_card.to_param, :credit_card => valid_attributes}, valid_session
        response.should redirect_to(credit_card)
      end
    end

    describe "with invalid params" do
      it "assigns the credit_card as @credit_card" do
        credit_card = CreditCard.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CreditCard.any_instance.stub(:save).and_return(false)
        put :update, {:id => credit_card.to_param, :credit_card => { "firstname" => "invalid value" }}, valid_session
        assigns(:credit_card).should eq(credit_card)
      end

      it "re-renders the 'edit' template" do
        credit_card = CreditCard.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CreditCard.any_instance.stub(:save).and_return(false)
        put :update, {:id => credit_card.to_param, :credit_card => { "firstname" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested credit_card" do
      credit_card = CreditCard.create! valid_attributes
      expect {
        delete :destroy, {:id => credit_card.to_param}, valid_session
      }.to change(CreditCard, :count).by(-1)
    end

    it "redirects to the credit_cards list" do
      credit_card = CreditCard.create! valid_attributes
      delete :destroy, {:id => credit_card.to_param}, valid_session
      response.should redirect_to(credit_cards_url)
    end

    it 'redirect to root if havent destroy ability' do
      allow(@controller).to receive(:current_ability).and_return(ability)
      ability.cannot :destroy, CreditCard
      delete :destroy, {id: '1'}
      response.should redirect_to(root_url)
    end
  end

end
