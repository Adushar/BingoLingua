class CreateJsLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :js_logs do |t|
      t.text :errors_arr
      t.timestamps
    end
  end
end
