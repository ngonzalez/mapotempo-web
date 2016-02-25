require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  set_fixture_class delayed_jobs: Delayed::Backend::ActiveRecord::Job

  test 'should not save' do
    o = order_arrays(:order_array_one).orders.build
    assert_not o.save, 'Saved without required fields'
  end

  test 'should save' do
    o = order_arrays(:order_array_one).orders.build(order_array: order_arrays(:order_array_one) , visit: visits(:visit_one), shift: 0)
    assert o.save
  end

  test 'should duplicate' do
    o = orders(:order_one)
    assert 2, o.products.size

    oo = o.amoeba_dup
    assert 2, oo.products.size
  end
end
