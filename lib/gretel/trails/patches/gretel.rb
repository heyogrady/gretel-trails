module ResetWithTrails
  def reset!
    super
    Gretel::Trails.reset!
  end
end

Gretel.send :prepend, ResetWithTrails
