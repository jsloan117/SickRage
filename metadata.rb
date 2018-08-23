name 'SickRage'
maintainer 'Jonathan Sloan'
maintainer_email 'jsloan117@gmail.com'
license 'GPL-3.0'
description 'Installs/Configures SickRage'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 14.0' if respond_to?(:chef_version)

issues_url 'https://github.com/jsloan117/SickRage/issues'
source_url 'https://github.com/jsloan117/SickRage'

supports 'centos', '>= 7.0'
supports 'debian', '>= 8.0'
supports 'fedora', '>= 27.0'
supports 'linuxmint', '>= 17.0'
supports 'ubuntu', '>= 16.04'

depends 'yum-epel', '>= 3.2.0'
depends 'yumgroup', '>= 0.6.0'
