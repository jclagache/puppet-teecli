require 'spec_helper_acceptance'

describe 'teecli class' , :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'teecli': }
      EOS
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end  
end