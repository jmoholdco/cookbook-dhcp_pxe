#
# Cookbook Name:: dhcp_pxe
# Spec:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 J. Morgan Lieberthal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

RSpec.describe 'dhcp_pxe::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  %w(7.0 7.1.1503).each do |version|
    context "on centos v#{version}" do
      let(:opts) { { platform: 'centos', version: version } }
      include_examples 'converges successfully'

      it 'installs the yum_package dhcp' do
        expect(chef_run).to install_yum_package('dhcp')
      end

      it 'creates the configuration file template' do
        expect(chef_run).to create_template('/etc/dhcp/dhcpd.conf').with(
          source: 'dhcpd.conf.erb',
          owner: 'root',
          group: 'root'
        )
      end

      it 'installs the tftp packages' do
        expect(chef_run).to install_yum_package('tftp')
        expect(chef_run).to install_yum_package('tftp-server')
        expect(chef_run).to install_yum_package('syslinux')
        expect(chef_run).to install_yum_package('wget')
        expect(chef_run).to install_yum_package('vsftpd')
      end

      it 'creates the template for /etc/xinetd.d/tftp' do
        expect(chef_run).to create_template('/etc/xinetd.d/tftp').with(
          owner: 'root',
          group: 'root',
          mode: '0644'
        )
      end

      it 'creates the tftpboot directory' do
        expect(chef_run).to create_directory('/var/lib/tftpboot').with(
          mode: '0777'
        )
      end

      it 'creates the syslinux files' do
        expect(chef_run).to create_cookbook_file('/var/lib/tftpboot/pxelinux.0')
        expect(chef_run).to create_cookbook_file('/var/lib/tftpboot/menu.c32')
        expect(chef_run).to create_cookbook_file('/var/lib/tftpboot/memdisk')
        expect(chef_run).to create_cookbook_file('/var/lib/tftpboot/mboot.c32')
        expect(chef_run).to create_cookbook_file('/var/lib/tftpboot/chain.c32')
      end

      it 'creates the subdirectories for tftpboot' do
        expect(chef_run).to create_directory('/var/lib/tftpboot/pxelinux.cfg')
        expect(chef_run).to create_directory('/var/lib/tftpboot/netboot/')
      end
    end
  end
end
