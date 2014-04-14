package { "vim":
  ensure => latest
}

node 'api' {
  $group = 'deploy'
  $user = 'deploy'
  $home = '/home/deploy'

  group { $group:
    ensure => present,
  }->
  user { $user:
    ensure   => present,
    gid      => $group,
    shell    => '/bin/bash',
    home     => $home,
    comment  => 'deploy user'
  }->
  file { [$home,
          "$home/.ssh"]:
    ensure => 'directory',
    owner  => $user,
    group  => $group
  }->
  file { "$home/.ssh/authorized_keys":
    content  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFil+rudpl92tedkYrDrJuwDjDySkgPsbEy1dGk300H4u+7/0tjTr/f6iOuMKsJOLzS/zyVSIsyOAB2E99b8oe4D0oqAdBASmW6LOOYVvgEcsE5YEfiexgfYnwxnt39OYkEeD9V+t5EiVqyRgWrppzfqDQZo0c+ps9nEDJ1EV5dIczH4L4emlXabhxrMLboTLRHR7Qj1R78TPculiif7QD7gqhsGxeNhcNIMdIC3V3flkp2aB4Lfuns5Y50JIracQqHeo3rYtyWxvc7CPI1DEfpDdfYnbUA5bVVPWexZlr2DAgmZbc4w1h7wsD6YY2edvyrn9bI20/Ynj7fpeoE+F/ calinoiu.alexandru@agilefreaks.com',
    mode    => '600',
    owner   => $user,
    group   => $group,
  }

  $gemset = 'omniapi'
  $rvm_version = '1.25.22'
  $ruby_version = '2.1.1'

  class { 'rvm':
    version => $rvm_version
  }->
  file { '/etc/rvmrc':
    content => "umask u=rwx,g=rwx,o=rx\nrvm_trust_rvmrcs_flag=1\n",
    require => Class['rvm']
  }->
  rvm_system_ruby { $ruby_version:
    ensure      => present,
    default_use => true
  }->
  rvm_gem { "$ruby_version/puppet":
    ensure  => latest
  }->
  rvm_gemset { "$ruby_version@$gemset":
    ensure  => present
  }->
  rvm::system_user { "$user": }

  $app_name = 'omniapi_staging'
  $deploy_to = '/var/www'

  file { [$deploy_to,
          "$deploy_to/$app_name",
          "$deploy_to/$app_name/releases",
          "$deploy_to/$app_name/shared",
          "$deploy_to/$app_name/shared/log",
          "$deploy_to/$app_name/shared/tmp",
          "$deploy_to/$app_name/shared/tmp/sockets",
          "$deploy_to/$app_name/shared/tmp/pids"]:
    ensure => 'directory',
    owner  => $user,
    group  => $group
  }

  $app_directory = '/var/www/omniapi_staging'

  $cache_config = {
       'gzip_static' => 'on',
       'expires'     => 'max',
       'add_header'  => 'Cache-Control public'
      }

  class { 'nginx': }

  nginx::resource::upstream { "$app_name":
    ensure  => present,
    members => ["unix:$deploy_to/$app_name/shared/tmp/sockets/puma.sock"]
  }->
  nginx::resource::vhost { "${hostname}staging.${::domain}":
    ensure => present,
    rewrite_to_https => true,
    ssl              => true,
    ssl_cert         => "/vagrant/certs/omnipasteapp.com.crt",
    ssl_key          => "/vagrant/certs/omnipasteapp.com.key.nopass",
    access_log => "$deploy_to/$app_name/shared/log/nginx_access.log",
    error_log => "$deploy_to/$app_name/shared/log/nginx_error.log",
    location_cfg_append => $cache_config,
    proxy => "http://$app_name/"
  }
}

node /^mongo[0-2]$/ {
  class { '::mongodb::globals':
    manage_package_repo => true,
  }->
  class { '::mongodb::server': 
    bind_ip => ['127.0.0.1',"$ipaddress_eth0"],
    replset    => 'rsomni'
  }->
  class { '::mongodb::client': }

  exec { 'open firewall port for mongo':
    command => "/sbin/iptables -A INPUT -s $ipaddress_eth0 -p tcp --destination-port 27017 -m state --state NEW,ESTABLISHED -j ACCEPT && 
                /sbin/iptables -A OUTPUT -d $ipaddress_eth0 -p tcp --source-port 27017 -m state --state ESTABLISHED -j ACCEPT",
    refreshonly => true
  }
}
