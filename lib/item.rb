require 'bigdecimal'
require 'time'

class Item
attr_reader   :name,
              :id,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id

  def initialize(data, ir = nil)
    @ir          = ir
    @id          = data[:id].to_i
    @name        = data[:name].to_s
    @description = data[:description].to_s
    @unit_price  = BigDecimal.new(data[:unit_price]) /100
    @created_at  = Time.parse(data[:created_at])
    @updated_at  = Time.parse(data[:updated_at])
    @merchant_id = data[:merchant_id].to_i
  end

  def unit_price_to_dollars(unit_price)
    unit_price.to_f
  end

  def merchant
    @ir.fetch_merchant(merchant_id)
  end
end
