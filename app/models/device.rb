class Device < ActiveRecord::Base
  belongs_to :firm
  validates :firm_id, :numericality => { :only_integer => true }
  validates :last_date, :numericality => { :only_integer => true }
  validates :imei,:firm_id,:last_date, :presence => true
  
  scope :with_id_user_and_firm, -> (id, user_id, firm_id) { includes(firm: :user).joins(firm: :user).where(id: id, firms: {id: firm_id}, users: {id: user_id}) }
end
