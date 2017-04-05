class e19base::install {

  exec { 'yum update -y':
    path  => '/usr/bin:/usr/sbin:/bin'
  }

  class { 'collectd':
    purge           => true,
    recurse         => true,
    purge_config    => true,
    minimum_version => '5.4'
  }

  class { 'collectd::plugin::logfile':
    log_level => 'info',
    log_file  => '/var/log/collectd.log'
  }

  class { 'collectd::plugin::df':
    mountpoints      => [ '/tmp' ],
    ignoreselected   => false
  }

  collectd::plugin { 'aggregation': }
  collectd::plugin { 'cpu': }
  collectd::plugin { 'disk': }
  collectd::plugin { 'interface': }
  collectd::plugin { 'load': }
  collectd::plugin { 'memory': }
  collectd::plugin { 'network': }

  class { 'cloudwatchlogs':
    region => 'us-east-1',
    logs    => {
      'Messages'           => { path => '/var/log/messages' },
      'Secure'             => { path => '/var/log/secure' },
      'cloud-init-output'  => { path => '/var/log/cloud-init-output.log' },
      'collectd'           => { path => '/var/log/collectd.log'}
    }
  }

}
