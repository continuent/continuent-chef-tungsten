
describe 'tungsten::service' do

  let(:chef_run) {
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5') do |node|
      node.set['tungsten']['systemUser'] = 'bob'
      node.set['tungsten']['homeDir'] = '/home/bob'
    end.converge(described_recipe)
  }

  it 'should create an init.d script' do
    expect(chef_run).to create_template('/etc/init.d/tungsten').with({
      owner: 'root',
      mode: 0755
    })
  end

  it 'should allow the init.d script to start tungsten' do
    expect(chef_run).to render_file('/etc/init.d/tungsten').with_content(/start\(\) \{{\n|\s}*su - bob -c \/home\/bob\/tungsten\/cluster-home\/bin\/startall &/)
  end

  it 'should allow the init.d script to stop tungsten' do
    expect(chef_run).to render_file('/etc/init.d/tungsten').with_content(/stop\(\) \{{\n|\s}*su - bob -c \/home\/bob\/tungsten\/cluster-home\/bin\/stopall &/)
  end

  it 'should enable the script' do
    expect(chef_run).to run_execute('chkconfig --add tungsten && chkconfig --level 2345 tungsten on')
  end

  it 'should define a tungsten service resource' do
    resource = chef_run.service('tungsten')
    expect(resource).to do_nothing
    expect(resource.supports).to eq({:status => true, :start => true, :stop => true, :restart => true})
  end

end