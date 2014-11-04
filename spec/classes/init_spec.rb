require 'spec_helper'
describe 'teecli' do
  let(:title) { 'teecli' }
  context 'with defaults for all parameters' do
  	let(:facts) {{ :kernel => 'Linux' }}
    it { should contain_class('teecli') }
    it do should contain_wget__fetch('teecli').with(
		'source' => 'http://download.microsoft.com/download/F/0/4/F04E054B-9DB5-4C24-AF84-DF1A290F5C73/TEE-CLC-12.0.2.zip',
		'destination' => '/usr/local/src/TEE-CLC-12.0.2.zip'
	) end
	it { should contain_exec('unpack-teecli') }
	it { should contain_file('/etc/profile.d/teecli.sh') }
    it { should contain_file('/usr/bin/tf') }
  end
end
