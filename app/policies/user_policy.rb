class UserPolicy < ApplicationPolicy
  # attr_reader :user

  # def initialize(user, record)
  #   @user = user
  #   @record = record
  # end

  def index?
    user.manager?
  end

  def show?
    user.manager?
  end

  def create?
    user.manager?
  end
  
  def update?
    user.manager?
  end

  def destroy?
    user.manager?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
