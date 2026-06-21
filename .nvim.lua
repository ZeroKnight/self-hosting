-- Recognize Quadlets in this repository tree
vim.filetype.add {
  pattern = {
    ['.*/self%-hosting/containers/.*%.artifact'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.build'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.container'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.image'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.kube'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.network'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.pod'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.volume'] = 'systemd',
    ['.*/self%-hosting/containers/.*%.d/.*%.conf'] = 'systemd',
  },
}
