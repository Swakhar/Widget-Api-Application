class Widget < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :kind, presence: true

  validates_inclusion_of :kind, in: %w(visible hidden)

  scope :visible, -> { where(kind: 'visible') }

  belongs_to :user
end
