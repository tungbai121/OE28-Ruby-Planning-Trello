class Ability
  include CanCan::Ability

  def initialize user
    user_abilities user
    board_abilities user
    list_abilities user
    tag_abilities user

    can :manage, Label
    cannot %i(create update destroy), Label do |label|
      UserBoard.user_role(user.id, label.board.id).blank?
    end

    can :manage, Checklist
    cannot %i(create update destroy), Checklist do |checklist|
      UserBoard.user_role(user.id, checklist.tag.list.board.id).blank?
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

  def tag_abilities user
    can :manage, Tag
    cannot %i(create update destroy), Tag do |tag|
      UserBoard.user_role(user.id, tag.list.board.id).blank?
    end
  end

  def user_abilities user
    can :manage, User if user.present?
  end
end
