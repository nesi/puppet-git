require 'spec_helper'
describe 'git::config', :type => :define do
  context 'on a Debian OS' do
    let :facts do
      {
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
        :fqdn             => 'test.example.org'
      }
    end
    let :title do
      'test.key'
    end
    context 'with dependencies defined correctly' do
      let :pre_condition do
        "include git\nuser{'tester': home => '/home/tester'}\nvcsrepo{'/path/to/repo': ensure => 'present', provider => 'git', path => '/path/to/repo'}"
      end
      
      describe 'with no parameters' do
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --system --unset test.key',
          'path'        => ['/bin','/usr/bin'],
          'unless'      => '! /usr/bin/git config --system test.key',
          'require'     => 'Package[git]'
        ) }
        it { should contain_exec('git_config_test.key').without('user') }
        it { should contain_exec('git_config_test.key').without('cwd') }
        it { should contain_exec('git_config_test.key').without('environment') }
      end
      describe 'when unsetting a system config value' do
        let :params do
          {
            :provider => 'system'
          }
        end
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --system --unset test.key',
          'path'        => ['/bin','/usr/bin'],
          'unless'      => '! /usr/bin/git config --system test.key',
          'require'     => 'Package[git]'
        ) }
        it { should contain_exec('git_config_test.key').without('user') }
        it { should contain_exec('git_config_test.key').without('cwd') }
        it { should contain_exec('git_config_test.key').without('environment') }
      end
      describe 'when setting a system config value' do
        let :params do
          {
            :provider => 'system',
            :value    => 'test value'
          }
        end
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --system test.key \'test value\'',
          'path'        => ['/bin','/usr/bin'],
          'unless'      => '/usr/bin/git config --system test.key| /bin/grep \'^test value$\'',
          'require'     => 'Package[git]'
        ) }
        it { should contain_exec('git_config_test.key').without('user') }
        it { should contain_exec('git_config_test.key').without('cwd') }
        it { should contain_exec('git_config_test.key').without('environment') }
      end
      describe 'when unsetting a global config value' do
        let :params do
          {
            :provider => 'global',
            :user     => 'tester'
          }
        end
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --global --unset test.key',
          'path'        => ['/bin','/usr/bin'],
          'user'        => 'tester',
          'cwd'         => '/home/tester',
          'environment' => 'HOME=/home/tester',
          'unless'      => '! /usr/bin/git config --global test.key',
          'require'     => ['Package[git]','User[tester]']
        ) }
      end
      describe 'when setting a global config value' do
        let :params do
          {
            :provider => 'global',
            :user     => 'tester',
            :value    => 'test value'
          }
        end
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --global test.key \'test value\'',
          'path'        => ['/bin','/usr/bin'],
          'user'        => 'tester',
          'cwd'         => '/home/tester',
          'environment' => 'HOME=/home/tester',
          'unless'      => '/usr/bin/git config --global test.key| /bin/grep \'^test value$\'',
          'require'     => ['Package[git]','User[tester]']
        ) }
      end
      describe 'when setting a global config value without a user' do
        let :params do
          {
            :provider => 'global',
            :value    => 'test value'
          }
        end
        it { should raise_error(Puppet::Error, /When using the 'global' provider the git::config user parameter is required./) }
      end
      describe 'when unsetting a local config value' do
        let :params do
          {
            :provider => 'local',
            :repo     => '/path/to/repo'
          }
        end
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --local --unset test.key',
          'path'        => ['/bin','/usr/bin'],
          'cwd'         => '/path/to/repo',
          'unless'      => '! /usr/bin/git config --local test.key',
          'require'     => ['Package[git]','Vcsrepo[/path/to/repo]']
        ) }
        it { should contain_exec('git_config_test.key').without('user') }
        it { should contain_exec('git_config_test.key').without('environment') }
      end
      describe 'when setting a local config value' do
        let :params do
          {
            :provider => 'local',
            :repo     => '/path/to/repo',
            :value    => 'test value'
          }
        end
        it { should contain_exec('git_config_test.key').with(
          'command'     => '/usr/bin/git config --local test.key \'test value\'',
          'path'        => ['/bin','/usr/bin'],
          'cwd'         => '/path/to/repo',
          'unless'      => '/usr/bin/git config --local test.key| /bin/grep \'^test value$\'',
          'require'     => ['Package[git]','Vcsrepo[/path/to/repo]']
        ) }
        it { should contain_exec('git_config_test.key').without('user') }
        it { should contain_exec('git_config_test.key').without('environment') }
      end
      describe 'when setting a local config value without a repo' do
        let :params do
          {
            :provider => 'local',
            :value    => 'test value'
          }
        end
        it { should raise_error(Puppet::Error, /When using the 'local' provider the git::config repo parameter is required./) }
      end
      describe 'when using an unknown provider' do
        let :params do
          {
            :provider => 'unknown',
          }
        end
        it { should raise_error(Puppet::Error, /The provider 'unknown' is not known to git::config/) }
      end
    end
    context 'with a repository that doesn\'t use git' do
      let :pre_condition do
        "include git\nuser{'tester': home => '/home/tester'}\nvcsrepo{'/path/to/repo': ensure => 'present', provider => 'svn'}"
      end
      describe 'with no parameters' do
        it { should compile }
      end
      describe 'when setting a system config value' do
        let :params do
          {
            :provider => 'system'
          }
        end
        it { should compile }
      end
      describe 'when setting a local config value' do
        let :params do
          {
            :provider => 'local',
            :repo     => '/path/to/repo'
          }
        end
        it { should raise_error(Puppet::Error, /The target vcsrepo repository '\/path\/to\/repo' must be using the git provider/) }
      end
      describe 'when setting a global config value' do
        let :params do
          {
            :provider => 'global',
            :user     => 'tester'
          }
        end
        it { should compile }
      end
    end
  end
end