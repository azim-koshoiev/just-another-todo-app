class Todo < ApplicationRecord
  belongs_to :project
  acts_as_list scope: :project, add_new_at: :top

  validates :title, presence: true
end
