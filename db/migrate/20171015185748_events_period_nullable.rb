class EventsPeriodNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :events, :period, true
    change_column_default :events, :period, nil
  end
end
