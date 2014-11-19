require 'spec_helper'
describe 'git::user', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :fqdn             => 'test.example.org'
      }
    end
    let :pre_condition do
      "include git\nuser{'tester': home => '/home/tester'}"
    end
    let :title do
      'tester'
    end
    describe 'with no parameters' do
      it { should contain_git__config('tester_name').with(
        'config'   => 'user.name',
        'value'    => 'tester on test.example.org',
        'provider' => 'global',
        'user'     => 'tester'
      ) }
      it { should contain_git__config('tester_email').with(
        'config'   => 'user.email',
        'value'    => 'tester@test.example.org',
        'provider' => 'global',
        'user'     => 'tester'
      ) }
    end
    describe 'with parameters' do
      let :params do
        {
          :user       => 'nobody',
          :user_email => 'nobody@nowhere.org',
          :user_name  => 'Mister Nobody'
        }
      end
      it { should contain_git__config('nobody_name').with(
        'value'    => 'Mister Nobody',
        'user'     => 'nobody'
      ) }
      it { should contain_git__config('nobody_email').with(
        'value'    => 'nobody@nowhere.org',
        'user'     => 'nobody'
      ) }
    end
  end
end