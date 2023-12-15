class Event < ApplicationRecord
  enum status: { registered: 0, upcoming: 1 }
  has_many :bookings, dependent: :destroy
end
