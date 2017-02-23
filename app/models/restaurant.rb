class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true


  def build_review(review_params, current_user)
    review = reviews.new(review_params)
    review.user = current_user
    review
  end

end
