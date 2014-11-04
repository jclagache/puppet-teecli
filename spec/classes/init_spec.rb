require 'spec_helper'
describe 'teecli' do

  context 'with defaults for all parameters' do
    it { should contain_class('teecli') }
  end
end
