name 'sickrage_environment'
description 'SickRage environment file'

cookbook_versions(
  SickRage: '>= 0.1.0',
  yumgroup: '>= 0.6.0'
)

default_attributes(
  sickrage: {
    directory: {
      install_dir: '/data/sickrage',
      data_dir: '/data/sickrage',
      config_dir: '/data/sickrage',
      pid_dir: '/data/sickrage',
    },
    listen_port: '4443',
    nice_value: -20,
    python: {
      install_pip: true,
    },
    systemuser: true,
  }
)
