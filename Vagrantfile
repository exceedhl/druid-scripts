Vagrant::Config.run do |config|

  config.vm.define :u64 do |config|
    config.vm.network :hostonly, "33.33.33.14"
    config.vm.box = "ubuntu64"
    config.vm.customize ["modifyvm", :id, "--memory", "2048"]
    config.vm.customize ["modifyvm", :id, "--cpus", "2"] # druid overlord requires multi-core machine
    config.vm.customize ["modifyvm", :id, "--ioapic", "on"]
  end

end
