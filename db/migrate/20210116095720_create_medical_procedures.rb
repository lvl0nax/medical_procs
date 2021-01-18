class CreateMedicalProcedures < ActiveRecord::Migration[6.1]
  def change
    create_table :medical_procedures do |t|
      t.string :title, null: false

      t.timestamps
    end
  end
end
