class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :read, User
    can %i(update destroy), User, id: user.id
    can :read, Widget
    can %i(update destroy), Widget, user_id: user.id
  end
end
