# == Schema Information
#
# Table name: medical_procedures
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MedicalProcedure < ApplicationRecord
  validates :title, uniqueness: true

  scope :ilike, -> (query) { where('title ILIKE ?', "%#{query}%") }

  def self.ilike_with_order(query)
    return all if query.blank?

    sort_condition = sanitize_sql_for_order([Arel.sql("position(? in lower(title))"), query])
    ilike(query).order(sort_condition)
  end
end

