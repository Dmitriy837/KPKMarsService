class FtpServer < ActiveRecord::Base
  belongs_to :firm
  validates :firm_id, :numericality => { :only_integer => true }
  validates :port, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :url, :port, :username, :firm_id, :presence => true
  
  scope :with_id_user_and_firm, -> (id, user_id, firm_id) { includes(firm: :user).joins(firm: :user).where(id: id, firms: {id: firm_id}, users: {id: user_id}) }
end

