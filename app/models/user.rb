class User < ApplicationRecord
  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :password, presence: true, if: -> { provider == 'standard' }
end
