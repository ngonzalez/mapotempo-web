require 'test_helper'

class V01::StoresTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include ActionDispatch::TestProcess
  set_fixture_class delayed_jobs: Delayed::Backend::ActiveRecord::Job

  def app
    Rails.application
  end

  setup do
    @store = stores(:store_one)
  end

  def api(part = nil, param = {})
    part = part ? '/' + part.to_s : ''
    "/api/0.1/stores#{part}.json?api_key=testkey1&" + param.collect{ |k, v| "#{k}=" + URI.escape(v.to_s) }.join('&')
  end

  test 'should return customer''s stores' do
    get api()
    assert last_response.ok?, last_response.body
    assert_equal @store.customer.stores.size, JSON.parse(last_response.body).size
  end

  test 'should return customer''s stores by ids' do
    get api(nil, 'ids' => @store.id)
    assert last_response.ok?, last_response.body
    assert_equal 1, JSON.parse(last_response.body).size
    assert_equal @store.id, JSON.parse(last_response.body)[0]['id']
  end

  test 'should return a store' do
    get api(@store.id)
    assert last_response.ok?, last_response.body
    assert_equal @store.name, JSON.parse(last_response.body)['name']
  end

  test 'should create a store' do
    assert_difference('Store.count', 1) do
      @store.name = 'new dest'
      post api(), @store.attributes
      assert last_response.created?, last_response.body
    end
  end

  test 'should create bulk from csv' do
    assert_difference('Store.count', 1) do
      put api(), replace: false, file: fixture_file_upload('files/import_stores_one.csv', 'text/csv')
      assert last_response.ok?, last_response.body
      json = JSON.parse(last_response.body)
      assert_equal 1, json.size
      assert_equal 'fra', json[0]['country']
      assert_equal 'fa-car', json[0]['icon']
    end
  end

  test 'should replace from csv' do
    put api(), replace: true, file: fixture_file_upload('files/import_stores_one.csv', 'text/csv')
    assert last_response.ok?, last_response.body
    assert_equal 1, JSON.parse(last_response.body).size
    assert_equal Store.where("customer_id='#{customers(:customer_one).id}'").count, 1
  end

  test 'should create bulk from json' do
    assert_difference('Store.count', 1) do
      put api(), {stores: [{
        name: 'Nouveau dépôt',
        street: nil,
        postalcode: nil,
        city: 'Tule',
        country: 'fra',
        lat: 43.5710885456786,
        lng: 3.89636993408203,
        ref: nil,
        geocoding_accuracy: nil,
        foo: 'bar',
        icon: 'fa-bars',
        icon_size: 'small',
      }]}
      assert last_response.ok?, last_response.body
      json = JSON.parse(last_response.body)
      assert_equal 1, json.size
      assert_equal 'fra', json[0]['country']
      assert_equal 'fa-bars', json[0]['icon']
      assert_equal 'small', json[0]['icon_size']
    end
  end

  test 'should update a store' do
    @store.name = 'new name'
    put api(@store.id), @store.attributes
    assert last_response.ok?, last_response.body

    get api(@store.id)
    assert last_response.ok?, last_response.body
    assert_equal @store.name, JSON.parse(last_response.body)['name']
  end

  test 'should destroy a store' do
    assert_difference('Store.count', -1) do
      delete api(@store.id)
      assert last_response.ok?, last_response.body
    end
  end

  test 'should destroy multiple stores' do
    assert_difference('Store.count', -2) do
      delete api + "&ids=#{stores(:store_one).id},#{stores(:store_one_bis).id}"
      assert last_response.ok?, last_response.body
    end
  end

  test 'should destroy multiple stores with ref' do
    assert_difference('Store.count', -2) do
      delete api + "&ids=ref:#{stores(:store_one).ref},ref:#{stores(:store_one_bis).ref}"
      assert last_response.ok?, last_response.body
    end
  end

  test 'should geocode' do
    patch api('geocode'), format: :json, store: { city: @store.city, name: @store.name, postalcode: @store.postalcode, street: @store.street }
    assert last_response.ok?, last_response.body
  end

  test 'should geocode complete' do
    patch api('geocode_complete'), format: :json, id: @store.id, store: { city: 'Montpellier', street: 'Rue de la Chaînerais' }
    assert last_response.ok?, last_response.body
  end
end
