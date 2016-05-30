# Class: puppetboard
# ===========================
#
# Install and Setup puppetboard for PCP
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `puppetboard_docroot`
# path to deploy puppetboard to.
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `puppetboard_docroot`
#  Optional
#  should be set the path to install into
#  e.g. puppetboard_docroot => '/var/www/html/puppetboard'
#
# Examples
# --------
#
# @example
#    class { 'puppetboard':
#    }
#
# Authors
# -------
#
# Adriano Vieira <adriano.svieira at gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Adriano Vieira, unless otherwise noted.
#
class puppetboard (
  $puppetboard_docroot = '/var/www/html/puppetboard'
  )
  {

  file { 'puppetboard_wsgi':
    path   => "${puppetboard_docroot}/puppetboard.wsgi",
    source => 'puppet:///modules/puppetboard/wsgi-dist.py'
  }

  file { 'puppetboard_settings':
    path   => "${puppetboard_docroot}/settings.py",
    source => 'puppet:///modules/puppetboard/settings-dist.py',
  }

  class { 'epel': }
  ->
  package { 'python-pip': ensure => present }
  ->
  exec {'puppetboard_install':
    path    => '/usr/bin',
    command => 'pip install puppetboard',
    onlyif  => 'test ! `pip list|grep puppetboard|wc -l` -eq 1',
  }

  include 'apache::mod::wsgi'
  apache::vhost { "puppetboard.${::domain}_wsgi":
    servername          => "puppetboard.${::domain}",
    priority            => '04',
    port                => '443',
    ssl                 => true,
    docroot             => $puppetboard_docroot,
    options             => '-Indexes',
    wsgi_script_aliases => {
      '/' => "${puppetboard_docroot}/puppetboard.wsgi"
    },
  }

}
