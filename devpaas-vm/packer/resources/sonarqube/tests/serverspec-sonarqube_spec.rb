require 'spec_helper'

describe service('sonarqube'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe port(9000) do
  it { should be_listening }
end
