require 'test_helper'

require 'rexml/document'
include REXML

class OrderArraysControllerTest < ActionController::TestCase
  set_fixture_class delayed_jobs: Delayed::Backend::ActiveRecord::Job

  setup do
    @request.env['reseller'] = resellers(:reseller_one)
    @order_array = order_arrays(:order_array_one)
    sign_in users(:user_one)
  end

  test 'user can only view vehicles from its customer' do
    ability = Ability.new(users(:user_one))
    assert ability.can? :manage, order_arrays(:order_array_one)
    ability = Ability.new(users(:user_three))
    assert ability.cannot? :manage, order_arrays(:order_array_one)
    sign_in users(:user_three)
    get :edit, id: @order_array
    assert_response :redirect
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_arrays)
    assert_valid response
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_valid response
  end

  test 'Create Order Array' do
    # EN
    I18n.locale = I18n.default_locale = :en
    assert_equal :en, I18n.locale
    assert_difference('OrderArray.count') do
      post :create, order_array: { name: 'test', length: 'week', base_date: '10-30-2016' }
    end
    assert_redirected_to edit_order_array_path(assigns(:order_array))
    assert assigns(:order_array).persisted?
    assert assigns(:order_array).base_date.strftime("%d-%m-%Y") == '30-10-2016'

    # FR
    I18n.locale = I18n.default_locale = :fr
    assert_equal :fr, I18n.locale
    assert_difference('OrderArray.count') do
      post :create, order_array: { name: 'test', length: 'week', base_date: '30-10-2016' }
    end
    assert_redirected_to edit_order_array_path(assigns(:order_array))
    assert assigns(:order_array).persisted?
    assert assigns(:order_array).base_date.strftime("%d-%m-%Y") == '30-10-2016'
  end

  test 'Update Order Array' do
    # EN
    I18n.locale = I18n.default_locale = :en
    assert_equal :en, I18n.locale
    patch :update, id: @order_array, order_array: { name: @order_array.name, base_date: '10-30-2016' }
    assert_redirected_to edit_order_array_path(assigns(:order_array))
    assert assigns(:order_array).persisted?
    assert assigns(:order_array).base_date.strftime("%d-%m-%Y") == '30-10-2016'

    # FR
    I18n.locale = I18n.default_locale = :fr
    assert_equal :fr, I18n.locale
    patch :update, id: @order_array, order_array: { name: @order_array.name, base_date: '30-10-2016' }
    assert_redirected_to edit_order_array_path(assigns(:order_array))
    assert assigns(:order_array).persisted?
    assert assigns(:order_array).base_date.strftime("%d-%m-%Y") == '30-10-2016'
  end

  test 'should not create order_array' do
    assert_difference('OrderArray.count', 0) do
      post :create, order_array: { name: '' }
    end

    assert_template :new
    order_array = assigns(:order_array)
    assert order_array.errors.any?
    assert_valid response
  end

  test 'should show order_array as excel' do
    get :show, id: @order_array, format: :excel
    assert_response :success
  end

  test 'should show order_array as csv' do
    get :show, id: @order_array, format: :csv
    assert_response :success
    assert_equal 'destination_one,MyString,P1/P2,1,1,2', response.body.split("\n")[1]
  end

  test 'should get edit' do
    get :edit, id: @order_array
    assert_response :success
    assert_valid response
  end

  test 'should not update order_array' do
    patch :update, id: @order_array, order_array: { name: '' }

    assert_template :edit
    order_array = assigns(:order_array)
    assert order_array.errors.any?
    assert_valid response
  end

  test 'should destroy order_array' do
    assert_difference('OrderArray.count', -1) do
      delete :destroy, id: @order_array
    end

    assert_redirected_to order_arrays_path
  end

  test 'should destroy multiple order_array' do
    assert_difference('OrderArray.count', -2) do
      delete :destroy_multiple, order_arrays: { order_arrays(:order_array_one).id => 1, order_arrays(:order_array_two).id => 1 }
    end

    assert_redirected_to order_arrays_path
  end

  test 'should duplicate' do
    assert_difference('OrderArray.count') do
      patch :duplicate, order_array_id: @order_array
    end

    assert_redirected_to edit_order_array_path(assigns(:order_array))
  end
end
