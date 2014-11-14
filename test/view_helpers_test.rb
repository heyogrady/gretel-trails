require 'test_helper'

class ViewHelpersTest < ActionView::TestCase
  include Gretel::ViewHelpers

  setup do
    Gretel.reset!
    Gretel::Trails::UrlStore.secret = "84f3196275c50b6fee3053c7b609b2633143f33f3536cb74abdf2753cca5a3e24b9dd93e4d7c75747c2f111821c7feb0e51e13485e4d772c17f60c1f8d832b72"
    @trail_param = "5c768d30fbd508470e4032079add097c5ba72638_W1siYWJvdXQiLCJBYm91dCIsMCwiaHR0cDovL3Rlc3QuaG9zdC9hYm91dCJdXQ=="
  end

  test "trail helper" do
    breadcrumb :about

    assert_equal @trail_param, breadcrumb_trail
  end

  test "loading trail" do
    params[:trail] = @trail_param
    breadcrumb :recent_products

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Recent products</span></div>},
                 breadcrumbs.to_s
  end

  test "different trail param" do
    Gretel::Trails.trail_param = :mytest
    params[:mytest] = @trail_param
    breadcrumb :recent_products

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <a href="/about">About</a> &rsaquo; <span class="current">Recent products</span></div>},
                 breadcrumbs.to_s
  end

  test "unknown trail" do
    params[:trail] = "notfound"
    breadcrumb :recent_products

    assert_equal %{<div class="breadcrumbs"><a href="/">Home</a> &rsaquo; <span class="current">Recent products</span></div>},
                 breadcrumbs.to_s
  end
end