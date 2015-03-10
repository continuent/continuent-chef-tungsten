Vagrant.configure('2') do |config|
  # Enable Vagrant Cachier, for speedy destroy/creates
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    config.cache.enable :generic, {
      :cache_dir => "/tmp/kitchen"
    }
  end
end