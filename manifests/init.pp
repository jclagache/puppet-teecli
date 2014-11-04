# == Class: teecli
#
# Full description of class teecli here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'teecli':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class teecli (
  $version = $teecli::params::version,
  $srcdir = $teecli::params::srcdir) inherits teecli::params {	

  case $::kernel {
   	'Linux': {
     		ensure_packages(['unzip'])
     		Package['unzip'] -> Exec['unpack-teecli']
   	}
    else {
      fail('This module only works on Linux')
    }
  }

  case $version {
   	'12.0.2': { $source = 'http://download.microsoft.com/download/F/0/4/F04E054B-9DB5-4C24-AF84-DF1A290F5C73/TEE-CLC-12.0.2.zip' }
     	default:  { 
     		$version = '12.0.2'
     		$source = 'http://download.microsoft.com/download/F/0/4/F04E054B-9DB5-4C24-AF84-DF1A290F5C73/TEE-CLC-12.0.2.zip'
     	}
  }

	wget::fetch { 'teecli':
   	source      => "$source",
   	destination => "${srcdir}/TEE-CLC-${version}.zip"
  } ->
  exec { 'unpack-teecli':
   	command => "unzip ${srcdir}/TEE-CLC-${version}.zip -d /usr/share/",
   	cwd     => '/usr/share/',
   	creates => "/usr/share/TEE-CLC-${version}",
   	path    => '/bin/:/usr/bin',
  } ->
  file { '/etc/profile.d/teecli.sh':
  	ensure => present,  		
  	owner => "root",
  	group => "root",
  	mode => 644,
  	content => template('teecli/teecli.sh.erb')
  } ->
  file { '/usr/bin/tf':
   	ensure => link,
   	target => "/usr/share/TEE-CLC-${version}/tf",
  }
}
