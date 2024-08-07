class ExchangeReturnPolicy < ApplicationRecord
  validates :heading, presence: true
  validates :description, presence: true
end
