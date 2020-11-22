class Ability
  include CanCan::Ability

  def initialize user
    user_abilities user
    board_abilities user
    list_abilities user
    card_abilities user

    can :manage, Label
    cannot %i(create update destroy), Label do |label|
      UserBoard.user_role(user.id, label.board.id).blank?
    end

    can :manage, Checklist
    cannot %i(create update destroy), Checklist do |checklist|
      UserBoard.user_role(user.id, checklist.card.list.board.id).blank?
    end
  end

  def board_abilities user
    can :manage, Board
    cannot :update, Board do |board|
      UserBoard.user_role(user.id, board.id).role_id.eql? "member"
    end
    cannot %i(update destroy), Board do |board|
      UserBoard.user_role(user.id, board.id).blank?
    end
  end

  def list_abilities user
    can :manage, List
    cannot %i(create update destroy), List do |list|
      UserBoard.user_role(user.id, list.board.id).blank?
    end
  end

  def card_abilities user
    can :manage, Card
    cannot %i(create update destroy), Card do |card|
      UserBoard.user_role(user.id, card.list.board.id).blank?
    end
  end

  def user_abilities user
    can :manage, User if user.present?
  end
end
