require 'bigdecimal'
require 'time'

class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at
  def initialize(data, iir = nil)
    @iir          = iir
    @id           = data[:id].to_i
    @item_id      = data[:item_id].to_i
    @invoice_id   = data[:invoice_id].to_i
    @quantity     = data[:quantity].to_i
    @unit_price   = BigDecimal.new(data[:unit_price]) /100
    @created_at   = Time.parse(data[:created_at])
    @updated_at   = Time.parse(data[:updated_at])
  end

  def unit_price_to_dollars(unit_price)
    unit_price.to_f
  end

end
