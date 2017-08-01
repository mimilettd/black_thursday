require 'pry'
require_relative 'sales_engine'
require 'bigdecimal'

class SalesAnalyst
 attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    merchant = sales_engine.merchants.all
    items = sales_engine.items.all

    average = (items.length.to_f)/(merchant.length)
    average.round(2)
  end

  def average_invoices_per_merchant
    merchant = sales_engine.merchants.all
    invoices = sales_engine.invoices.all

    average = (invoices.length.to_f)/(merchant.length)
    average.round(2)
  end

  def collected_items_hash
    all_merchants = {}
    mr = @sales_engine.merchants.all
    mr.each do |merchant|
      item = sales_engine.fetch_items(merchant.id)
      all_merchants[merchant.id] = item.length
    end
    all_merchants
  end

  def collected_invoices_hash
      all_invoices = {}
      mr = @sales_engine.merchants.all
      mr.each do |merchant|
        invoice = sales_engine.fetch_invoices(merchant_id)
        all_invoices[merchant.id] = invoice.length
      end
      all_invoices
  end

  def standard_deviation(values)
    average = values.reduce(:+)/values.length.to_f
    average_average = values.reduce(0) {|val, num| val += ((num - average)**2) }
    Math.sqrt(average_average / (values.length-1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    value = collected_items_hash.values
    standard_deviation(value)
  end

  def average_invoices_per_merchant_standard_deviation
    values = collected_invoices_hash.values
    standard_deviation(values)
  end

  def merchants_with_high_item_count
    mr = sales_engine.merchants.all
    v = average_items_per_merchant+average_items_per_merchant_standard_deviation
    mr.find_all do |merchant|
      merchant.items.length >= v
    end
  end

  def average_item_price_for_merchant(merchant_id)
    items = @sales_engine.fetch_items(merchant_id)
    sum = 0
    items.each do |item|
      sum += item.unit_price
    end

    average = sum/(items.length)
    average.round(2)
  end

  def average_average_price_per_merchant
    array_1 = []
    sales_engine.merchants.all.each do |merch|
      array_1 << average_item_price_for_merchant(merch.id)
    end
    array_2 = (array_1.reduce(:+)/array_1.length)
    array_2.round(2)
  end

  def golden_items
    ir = sales_engine.items.all
    prices = ir.map {|item| item.unit_price}
    dev = (average_average_price_per_merchant)+(standard_deviation(prices) * 2)
    ir.find_all do |item|
      item.unit_price >= dev
    end
  end

  def top_merchants_by_invoice_count
      top_merchants = average_inv_merch_plus_dev

      sales_engine.merchants.all.find_all do |merchant|
        merchant.invoices.count > top_merchants
      end
  end

  def times_by_two
    (average_invoices_per_merchant_standard_deviation * 2)
  end

  def average_inv_merch_plus_dev
    times_by_two + average_invoices_per_merchant
  end

  def average_inv_merch_minus_dev
    average_invoices_per_merchant - times_by_two
  end

  def bottom_merchants_by_invoice_count
    bottom_merchants = average_inv_merch_minus_dev

    sales_engine.merchants.all.find_all do |merchant|
      merchant.invoices.count < bottom_merchants
    end
  end

  def top_days_by_invoice_count
   invoices_per_day = create_invoices_per_day_hash
   values = invoices_per_day.values
   days = invoices_per_day.keys
   days.select {|day| invoices_per_day[day] > one_invoice_deviation(values)}
  end

  def average_invoices_per_day
   (sales_engine.invoices.all.length)/7
  end

  def one_invoice_deviation(values)
   (average_invoices_per_day + standard_deviation(values))
  end

  def create_invoices_per_day_hash
    invr = sales_engine.invoices.all
    invr.reduce({}) do |days, invoice|
     created_day = invoice.created_at.strftime("%A")
     days[created_day] = 0 unless days[created_day]
     days[created_day] += 1
     days
    end
  end

  def invoice_status(status)
    invr = sales_engine.invoices.all
    status_matches = invr.select {|invoice| invoice.status == status}
    percentage = (status_matches.length.to_f)/(invr.length) * 100
    percentage.round(2)
  end

  def total_revenue_by_date(date)
    invoices_by_date = sales_engine.invoices.find_all_by_created_at(date)
    result = invoices_by_date.map do |invoice|
      sales_engine.invoice_items.find_all_by_invoice_id(invoice.id)
    end
    total = 0
    result.flatten.each do |item|
      total += item.quantity * item.unit_price
    end
    total
  end

  def top_revenue_earners(x = 20)
    sales_engine.top_revenue_earners(x)
  end

end
