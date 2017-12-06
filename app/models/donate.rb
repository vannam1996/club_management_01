class Donate < ApplicationRecord
  belongs_to :event
  belongs_to :user

  after_update :update_event, if: ->{self.accept?}

  enum status: {pending: 0, accept: 1, reject: 2}

  scope :newest, ->{order created_at: :desc}

  delegate :full_name, :email, to: :user, allow_nil: :true

  private
  def update_event
    if self.event.present?
      self.event.update_attributes expense: self.event.expense + self.expense
      Event.calculate_get_donate event
    end
  end
end
