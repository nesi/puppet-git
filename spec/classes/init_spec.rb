require 'spec_helper'
describe 'git', :type => :class do
  context "on a Debian OS" do
    let :facts do
      {
        :osfamily         => 'Debian',
        :operatingsystem  => 'Debian',
      }
    end
    describe "with no parameters" do
      it { should contain_class('git::params') }
      it { should contain_package('git').with(
        'ensure'  => 'installed',
        'name'    => 'git'
      ) }
      it { should contain_package('git-svn').with(
        'ensure'  => 'installed',
        'name'    => 'git-svn'
      ) }
      it { should contain_package('git-gui').with(
        'ensure'  => 'absent',
        'name'    => 'git-gui'
      ) }
    end
    describe "with ensure => absent" do
      let :params do
        {
          :ensure => 'absent',
        }
      end
      it { should contain_class('git::params') }
      it { should contain_package('git').with(
        'ensure'  => 'absent'
      ) }
      it { should contain_package('git-svn').with(
        'ensure'  => 'absent'
      ) }
      it { should contain_package('git-gui').with(
        'ensure'  => 'absent'
      ) }
    end
    describe "with svn => absent" do
      let :params do
        {
          :svn => 'absent',
        }
      end
      it { should contain_class('git::params') }
      it { should contain_package('git-svn').with(
        'ensure'  => 'absent'
      ) }
    end
    describe "with gui => installed" do
      let :params do
        {
          :gui => 'installed',
        }
      end
      it { should contain_class('git::params') }
      it { should contain_package('git-gui').with(
        'ensure'  => 'installed'
      ) }
    end
  end

  context "on an later (post 11) Ubuntu OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '11',
      }
    end
    describe "with no parameters" do
      it { should contain_class('git::params') }
      it { should contain_package('git').with(
        'ensure'  => 'installed',
        'name'    => 'git'
      ) }
    end
  end

  context "on an early (pre 11) Ubuntu OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '10',
      }
    end
    describe "with no parameters" do
      it { should contain_class('git::params') }
      it { should contain_package('git').with(
        'ensure'  => 'installed',
        'name'    => 'git-core'
      ) }
    end
  end

  context "on a RedHat OS" do
    let :facts do
      {
        :osfamily   => 'RedHat',
      }
    end
    describe "with no parameters" do
      it { should contain_class('git::params') }
      it { should contain_package('git').with(
        'ensure'  => 'installed',
        'name'    => 'git'
      ) }
    end
  end

  context "on a ArchLinux OS" do
    let :facts do
      {
        :osfamily   => 'ArchLinux',
      }
    end
    describe "with no parameters" do
      it { should contain_class('git::params') }
      it { should contain_package('git').with(
        'ensure'  => 'installed',
        'name'    => 'git'
      ) }
    end
  end

  context "on an Unknown OS" do
    let :facts do
      {
        :osfamily   => 'Unknown',
      }
    end
    it { should raise_error(Puppet::Error, /The NeSI Git Puppet module does not support Unknown family of operating systems/) }
  end

end
