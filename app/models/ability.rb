class Ability
  include CanCan::Ability

  def initialize(customer)
    # Define abilities for the passed in user here. For example:
    #
    if customer
      if customer.admin?
        can :manage, :all
      else
        can :read, :all
        can :manage, [Address, CreditCard, Customer]
        can [:rate, :add_wished, :wished, :filter], Book
        can [:update, :add_item, :remove_item], Order
      end
    else
      can :read, Book
      #customer = Customer.new # guest user (not logged in)
    end
      
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end