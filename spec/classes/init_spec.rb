require 'spec_helper'
describe 'puppetboard' do
  context 'with default values for all parameters' do
    it { should contain_class('puppetboard') }
  end
end
