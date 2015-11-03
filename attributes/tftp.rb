default['tftp'] = {
  'server' => node['ipaddress'],
  'filename' => 'pxelinux. 0',
  'syslinux' => {
    'files' => %w( pxelinux.0 menu.c32 memdisk mboot.c32 chain.c32 )
  },
  'netboot_files' => %w(vmlinuz initrd.img)
}
