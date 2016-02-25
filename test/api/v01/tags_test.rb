require 'test_helper'

class V01::TagsTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  set_fixture_class delayed_jobs: Delayed::Backend::ActiveRecord::Job

  def app
    Rails.application
  end

  setup do
    @tag = tags(:tag_one)
  end

  def api(part = nil, param = {})
    part = part ? '/' + part.to_s : ''
    "/api/0.1/tags#{part}.json?api_key=testkey1&" + param.collect{ |k, v| "#{k}=" + URI.escape(v.to_s) }.join('&')
  end

  test 'should return customer''s tags' do
    get api()
    assert last_response.ok?, last_response.body
    assert_equal @tag.customer.tags.size, JSON.parse(last_response.body).size
  end

  test 'should return customer''s tags by ids' do
    get api(nil, 'ids' => @tag.id)
    assert last_response.ok?, last_response.body
    assert_equal 1, JSON.parse(last_response.body).size
    assert_equal @tag.id, JSON.parse(last_response.body)[0]['id']
  end

  test 'should return a tag' do
    get api(@tag.id)
    assert last_response.ok?, last_response.body
    assert_equal @tag.label, JSON.parse(last_response.body)['label']
  end

  test 'should create a tag' do
    assert_difference('Tag.count', 1) do
      @tag.label = 'new label'
      post api(), @tag.attributes
      assert last_response.created?, last_response.body
    end
  end

  test 'should update a tag' do
    @tag.label = 'new label'
    put api(@tag.id), label: 'riri', color: '#123456'
    assert last_response.ok?, last_response.body

    get api(@tag.id)
    assert last_response.ok?, last_response.body
    assert_equal 'riri', JSON.parse(last_response.body)['label']
    assert_equal '#123456', JSON.parse(last_response.body)['color']
  end

  test 'should destroy a tag' do
    assert_difference('Tag.count', -1) do
      delete api(@tag.id)
      assert last_response.ok?, last_response.body
    end
  end

  test 'should destroy multiple tags' do
    assert_difference('Tag.count', -2) do
      delete api + "&ids=#{tags(:tag_one).id},#{tags(:tag_two).id}"
      assert last_response.ok?, last_response.body
    end
  end
end
