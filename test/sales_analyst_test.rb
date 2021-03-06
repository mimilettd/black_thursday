require 'bigdecimal'
require './test/test_helper'
require './lib/sales_engine'
require './lib/sales_analyst'
require 'pry'


class SalesAnalystTest < MiniTest::Test

  def test_that_se_is_initialized
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 2.88, sa.average_items_per_merchant
  end


  def test_average_item_price_for_merchant
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 16.66, sa.average_item_price_for_merchant(12334105)
    assert_instance_of BigDecimal, sa.average_item_price_for_merchant(12334105)
  end

  def test_it_can_get_average_invoice
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 10.49, sa.average_invoices_per_merchant
  end

  def test_for_standard_deviation_on_items
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_it_can_get_average_invoice_standard_deviation
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)
    sa = SalesAnalyst.new(se)

    assert_equal 3.29, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 52, sa.merchants_with_high_item_count.length
  end


  def test_average_average_price_per_merchant
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)


    assert_equal 350.29, sa.average_average_price_per_merchant
  end

  def test_golden_items
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 5, sa.golden_items.length
  end

  def test_top_merchants_by_invoice_count
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 12, sa.top_merchants_by_invoice_count.length

  end

  def test_bottom_merchants_by_invoice_count
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 4, sa.bottom_merchants_by_invoice_count.length
  end

  def test_it_calculates_top_days_by_invoice_count
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal ["Wednesday"], sa.top_days_by_invoice_count
  end

  def test_it_calculates_percentage_of_invoices_status
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 29.55, sa.invoice_status(:pending)
    assert_equal 56.95, sa.invoice_status(:shipped)
    assert_equal 13.5, sa.invoice_status(:returned)
  end

  def test_it_returns_total_revenue_by_date
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)
    date = Time.parse("2009-02-07")
    assert_equal 21067.77, sa.total_revenue_by_date(date)
  end

  def test_for_merchants_with_only_one_item
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 243, sa.merchants_with_only_one_item.length
    assert_instance_of Array, sa.merchants_with_only_one_item
    assert_instance_of Merchant, sa.merchants_with_only_one_item[0]
  end

  def test_for_merchants_with_only_one_item_in_month
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_equal 24, sa.merchants_with_only_one_item_registered_in_month("May").length
    assert_instance_of Array, sa.merchants_with_only_one_item_registered_in_month("March")
    assert_instance_of Merchant, sa.merchants_with_only_one_item_registered_in_month("April")[0]
  end


  def test_it_returns_top_merchants
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)
    actual = sa.top_revenue_earners(10)
    assert_equal 10, actual.count
  end

  def test_it_returns_20_top_merchants_by_default
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)
    actual = sa.top_revenue_earners
    assert_equal 20, actual.count
  end

  def test_it_returns_merchants_with_pending_invoices
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)
    actual = sa.merchants_with_pending_invoices
    assert_equal 467, actual.count
  end

  def test_for_merchants_ranked_by_revenue
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_instance_of Merchant, se.merchants_ranked_by_revenue[0]
    # assert_instance_of Array, sa.merchants_ranked_by_revenue
  end

  def test_for_revenue_by_merchant
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_instance_of BigDecimal, sa.revenue_by_merchant(12334123)
  end

  def test_for_most_sold_item_for_merchant
    se = SalesEngine.from_csv({
      :items         => "./data/items.csv",
      :merchants     => "./data/merchants.csv",
      :invoices      => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv",
      :customers     => "./data/customers.csv"
      })
    sa = SalesAnalyst.new(se)

    assert_instance_of Array, sa.most_sold_item_for_merchant(12335938)
    assert_equal 3, sa.most_sold_item_for_merchant(12335938).length
  end
end
