class NumberChoosenValidator < ActiveModel::Validator
  def validate(record)
    if !record.license_count || record.license_count < 0
      record.errors[:license_count] << " not choosen"
    end
  end
end

class Firm < ActiveRecord::Base
  belongs_to :user
  has_many :ftp_servers
  has_many :parameters
  has_many :devices
  validates :user_id, :numericality => { :only_integer => true }
  validates :license_count, :numericality => { :only_integer => true }
  validates :description, :license_count, :user_id, :presence => true
  validates_with NumberChoosenValidator, :fields => [:license_count]
  
  scope :with_id_and_user, -> (id, user_id) { includes(:user).joins(:user).where(id: id, users: {id: user_id}) }
end
