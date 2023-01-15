class GameSession < ActiveRecord::Base
  validates :current_progress, presence: true
  validates :answer, presence: true
  validates :lives, presence: true
end
