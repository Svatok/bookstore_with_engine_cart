class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Product
    can :read, Review

    if user.persisted?
      can :manage, User, id: user.id
      can :create, Review
      can :read, EngineCart::Order, user_id: user.id
      can [:show, :update], :checkout
      can [:create, :read, :update, :destroy], EngineCart::OrderItem
      if user.role?(:admin)
        can :read, ActiveAdmin::Page, namespace_name: :admin
        can :manage, :all
      end
    end
  end
end
