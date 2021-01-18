# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless MedicalProcedure.exists?
  procedures = WikiPages::MedicalProceduresParser.call

  if procedures.present?
    sql = 'INSERT INTO medical_procedures (title, created_at, updated_at) VALUES '
    procedures.each { |procedure| sql << "('#{procedure}', 'NOW()', 'NOW()')," }

    ActiveRecord::Base.connection.execute(sql.chop!)
  end
end


