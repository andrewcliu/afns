class User < ApplicationRecord
  include Clearance::User

  # Define roles for users
  enum role: { basic_user: 0, premium_user: 1 }

  # Set defaults for new users
  after_initialize do
    self.role ||= :basic_user
    self.admin ||= false
  end

  # Custom validation to ensure only 2 users exist
  validate :user_count_within_limit, on: :create

  # Callback to prevent deletion if only two users exist
  before_destroy :prevent_deletion_if_only_two

  private

  def user_count_within_limit
    if User.count >= 2
      errors.add(:base, "Only two users are allowed in the system.")
    end
  end

  def prevent_deletion_if_only_two
    if User.count <= 2
      errors.add(:base, "Cannot delete user. The system requires exactly two users.")
      throw(:abort)
    end
  end
end
