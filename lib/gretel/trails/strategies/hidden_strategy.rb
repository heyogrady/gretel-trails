module Gretel
  module Trails
    module HiddenStrategy
      DEFAULT_JS_SELECTOR = ".js-append-trail"
      DEFAULT_DATA_ATTRIBUTE = "trail"

      class << self
        include Gretel::Resettable

        # jQuery selector for links that should have the trail appended
        # to them on click. Default: +.js-append-trail+
        def js_selector
          @js_selector ||= DEFAULT_JS_SELECTOR
        end

        # Sets the jQuery link selector.
        attr_writer :js_selector

        # Name of the HTML data attribute that will contain the trail
        # when it is hidden. Default: +trail+
        def data_attribute
          @data_attribute ||= DEFAULT_DATA_ATTRIBUTE
        end

        # Sets the HTML data attribute.
        attr_writer :data_attribute
      end
    end
  end
end

Gretel::Trails.class_eval do
  class << self
    def hidden
      Gretel::Trails::HiddenStrategy
    end
  end
end

module ResetWithHidden
  def reset!
    super
    hidden.reset!
  end
end

Gretel::Trails.send :prepend, ResetWithHidden

module BreadcrumbLinkToWithHiddenTrail
  def breadcrumb_link_to(name, url, options = {})
    if url.include?("#{Gretel::Trails.trail_param}=")
      uri = URI.parse(url)
      query_hash = Hash[CGI.parse(uri.query.to_s).map { |k, v| [k, v.first] }]
      trail = query_hash.delete(Gretel::Trails.trail_param.to_s)

      options = options.dup
      options[:data] ||= {}
      options[:data][Gretel::Trails::HiddenStrategy.data_attribute] = trail

      uri.query = query_hash.to_query.presence
      url = uri.to_s
    end

    super(name, url, options)
  end
end

Gretel::Renderer::LinkCollection.send :prepend, BreadcrumbLinkToWithHiddenTrail

ActionView::Base.class_eval do
  # View helper proxy to the breadcrumb renderer's breadcrumb_link_to that
  # automatically removes trails from URLs and adds them as data attributes.
  def breadcrumb_link_to(name, url, options = {})
    gretel_renderer.render.breadcrumb_link_to(name, url, options)
  end unless method_defined?(:breadcrumb_link_to)
end
