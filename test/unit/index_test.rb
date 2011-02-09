require 'test_helper'

module Slingshot

  class IndexTest < Test::Unit::TestCase

    context "Index" do

      setup do
        @index = Slingshot::Index.new 'dummy'
      end

      should "create new index" do
        Configuration.client.expects(:post).returns('{"ok":true,"acknowledged":true}')
        assert @index.create
      end

      should "not raise exception and just return false when trying to create existing index" do
        Configuration.client.expects(:post).raises(RestClient::BadRequest)
        assert_nothing_raised { assert ! @index.create }
      end

      should "delete index" do
        Configuration.client.expects(:delete).returns('{"ok":true,"acknowledged":true}')
        assert @index.delete
      end

      should "not raise exception and just return false when deleting non-existing index" do
        Configuration.client.expects(:delete).returns('{"error":"[articles] missing"}')
        assert_nothing_raised { assert ! @index.delete }
        Configuration.client.expects(:delete).raises(RestClient::BadRequest)
        assert_nothing_raised { assert ! @index.delete }
      end

      should "refresh the index" do
        Configuration.client.expects(:post).returns('{"ok":true,"_shards":{}}')
        assert_nothing_raised { assert @index.refresh }
      end

      context "when storing" do

        should "properly set type from args" do
          Configuration.client.expects(:post).with("#{Configuration.url}/dummy/article/", '{"title":"Test"}').returns('{"ok":true,"_id":"test"}').twice
          @index.store 'article', :title => 'Test'
          @index.store :article,  :title => 'Test'
        end

        should "set default type" do
          Configuration.client.expects(:post).with("#{Configuration.url}/dummy/document/", '{"title":"Test"}').returns('{"ok":true,"_id":"test"}')
          @index.store :title => 'Test'
        end

        should "call #to_indexed_json on non-String documents" do
          document = { :title => 'Test' }
          Configuration.client.expects(:post).returns('{"ok":true,"_id":"test"}')
          document.expects(:to_indexed_json)
          @index.store document
        end

        should "raise error when storing neither String nor object with #to_indexed_json method" do
          class MyDocument;end; document = MyDocument.new
          assert_raise(ArgumentError) { @index.store document }
        end

      end

    end

  end

end