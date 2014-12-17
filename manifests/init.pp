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
include stdlib

class teecli (
  $version = $teecli::params::version,
  $srcdir = $teecli::params::srcdir) inherits teecli::params {	

 if $::kernel == 'Linux' { 	
    ensure_packages(['unzip'])
    Package['unzip'] -> Exec['unpack-teecli']
  }
  else {
    fail('This module only works on Linux')
  }  

  $versions = {'12.0.2' => 'http://download.microsoft.com/download/F/0/4/F04E054B-9DB5-4C24-AF84-DF1A290F5C73/TEE-CLC-12.0.2.zip', '11.0.0.1306' => 'http://download.microsoft.com/download/4/2/7/427AC2CF-8A5B-4DE9-8221-22F54B1903E2/TEE-CLC-11.0.0.1306.zip', '10.1.0' => 'http://download.microsoft.com/download/C/B/A/CBA6331C-08CC-4E68-80F8-1E8D2BD41D82/TEE-CLC-10.1.0.2011121402.zip', '10.0.0' => 'http://download.microsoft.com/download/9/8/7/987D6B7C-F577-4297-8F60-E4B6A9EA4BF9/TEE-CLC-10.0.0.zip'} 

  if !has_key($versions, $version) {
    fail("$version is an unknow TEE-CLI version")
  }
  $url = $versions[$version]
	wget::fetch { 'teecli':
   	source      => "${url}",
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

  exec { '/etc/profile.d/teecli.sh':
      command     => 'sh /etc/profile.d/teecli.sh',
      refreshonly => true,
      subscribe   => File[ '/etc/profile.d/teecli.sh' ],
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
  }
  
}
