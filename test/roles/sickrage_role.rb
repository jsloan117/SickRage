name 'sickrage_role'
description 'SickRage role file'
run_list 'recipe[SickRage::default]'

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
