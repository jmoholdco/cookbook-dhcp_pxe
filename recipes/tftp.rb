#
# Cookbook Name:: dhcp_pxe
# Recipe:: tftp
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

yum_package 'tftp'
yum_package 'tftp-server'
yum_package 'syslinux'
yum_package 'vsftpd'
yum_package 'wget'

template '/etc/xinetd.d/tftp' do
  source 'tftp.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[xinetd]'
end

directory '/var/lib/tftpboot' do
  recursive true
  mode '0777'
  owner 'nobody'
  group 'nobody'
  action :create
end

directory '/var/lib/tftpboot/pxelinux.cfg' do
  recursive true
end

directory '/var/lib/tftpboot/netboot/' do
  recursive true
end

node['tftp']['syslinux']['files'].each do |file|
  cookbook_file "/var/lib/tftpboot/#{file}" do
    source "#{file}"
  end
end

node['tftp']['netboot_files'].each do |file|
  cookbook_file "/var/lib/tftpboot/netboot/#{file}" do
    source "#{file}"
  end
end

cookbook_file '/var/lib/tftpboot/pxelinux.cfg/default' do
  source 'default_menu'
end

service 'xinetd' do
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end
