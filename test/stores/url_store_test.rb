require 'test_helper'

class UrlStoreTest < ActiveSupport::TestCase
  setup do
    Gretel.reset!
    
    Gretel::Trails.store = :url
    Gretel::Trails::UrlStore.secret = "128107d341e912db791d98bbe874a8250f784b0a0b4dbc5d5032c0fc1ca7bda9c6ece667bd18d23736ee833ea79384176faeb54d2e0d21012898dde78631cdf1"
    
    @links = [
      [:root, "Home", "/"],
      [:store, "Store <b>Test</b>".html_safe, "/store"],
      [:search, "Search", "/store/search?q=test"]
    ]
  end

  test "encoding" do
    assert_equal "9680209e1942672b57009a385c3344bbb399ff7f_W1sicm9vdCIsIkhvbWUiLDAsIi8iXSxbInN0b3JlIiwiU3RvcmUgXHUwMDNDYlx1MDAzRVRlc3RcdTAwM0MvYlx1MDAzRSIsMSwiL3N0b3JlIl0sWyJzZWFyY2giLCJTZWFyY2giLDAsIi9zdG9yZS9zZWFyY2g_cT10ZXN0Il1d",
                 Gretel::Trails.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
  end

  test "decoding" do
    decoded = Gretel::Trails.decode("9680209e1942672b57009a385c3344bbb399ff7f_W1sicm9vdCIsIkhvbWUiLDAsIi8iXSxbInN0b3JlIiwiU3RvcmUgXHUwMDNDYlx1MDAzRVRlc3RcdTAwM0MvYlx1MDAzRSIsMSwiL3N0b3JlIl0sWyJzZWFyY2giLCJTZWFyY2giLDAsIi9zdG9yZS9zZWFyY2g_cT10ZXN0Il1d")
    assert_equal @links, decoded.map { |link| [link.key, link.text, link.url] }
    assert_equal [false, true, false], decoded.map { |link| link.text.html_safe? }
  end

  test "invalid trail" do
    assert_equal [], Gretel::Trails.decode("28f104524f5eaf6b3bd035710432fd2b9cbfd62c_X1sicm9vdCIsIkhvbWUiLDAsIi8iXSxbInN0b3JlIiwiU3RvcmUiLDAsIi9zdG9yZSJdLFsic2VhcmNoIiwiU2VhcmNoIiwwLCIvc3RvcmUvc2VhcmNoP3E9dGVzdCJdXQ==")
  end

  test "raises error if no secret set" do
    Gretel::Trails::UrlStore.secret = nil
    assert_raises RuntimeError do
      Gretel::Trails.encode(@links.map { |key, text, url| Gretel::Link.new(key, text, url) })
    end
  end
end