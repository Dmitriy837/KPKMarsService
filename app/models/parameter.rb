class Parameter < ActiveRecord::Base
  belongs_to :firm
  validates :firm_id, :numericality => { :only_integer => true }
  validates_uniqueness_of :firm_id, :scope => [:param_name]
  validates :param_name, :param_value, :presence => true
  
  scope :with_id_user_and_firm, -> (id, user_id, firm_id) { includes(firm: :user).joins(firm: :user).where(id: id, firms: {id: firm_id}, users: {id: user_id}) }
end
