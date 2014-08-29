#!/usr/bin/env ruby
#^syntax detection

$server_values = hiera('server', false)
$wordpress_values = hiera('wordpress', false)
$mysql_values = hiera('mysql', false)

class fileDeps {

    file {
        $wordpress_values['config_file']:
            ensure => file
    }

    file {
        $dbFile:
            ensure => file
    }

}

class { 'timezone':
    timezone => $server_values['timezone'],
}

class system_packages {
    include gcc

    package {
        'bundler':
            ensure   => 'installed',
            provider => 'gem',
    }

    package {
        "git":
            ensure => latest
    }

    package {
        'make':
            ensure  => present
    }

    package {
        'nano':
            ensure => present
    }

    package {
        'htop':
            ensure => present
    }

    class { 'nodejs':
        version => 'stable',
        make_install => false
    }

    package {
        "yo":
            provider => 'npm',
            require => Class['nodejs']
    }

    package {
        "grunt-cli":
            provider => 'npm',
            require => Class['nodejs']
    }

}

class lamp {
    require system_packages

    class {
        'apache':
            mpm_module => 'prefork',
            servername => 'localhost',
            default_vhost => false,
            user => 'vagrant',
            group => 'vagrant',
            sendfile => 'Off'
    }

    class { 'apache::mod::php': }
    class { 'apache::mod::suphp':  }

    apache::vhost {
        'localhost':
            port => '80',
            docroot => '/vagrant/www',
            directories  => [
                {
                    path => '/vagrant/www',
                    options => ['Indexes', 'FollowSymLinks', 'MultiViews'],
                    allow_override => ['All']
                }
            ];
    }

    # PHP
    class { 'php': }

    # Curl
    php::module { 'common': }

    # PHP-GD
    php::module { 'gd': }

    # PHP-XML
    php::module { 'xml': }

    file_line {
        'display_errors':
            ensure => present,
            path => $server_values['php_ini'],
            line => "display_errors = On"
    }

    file_line {
        'session_save_path':
            ensure => present,
            path => $server_values['php_ini'],
            line => 'session.save_path = "/tmp"'
    }

    # Hosts File mimics prod
    host {
        'mysql':
            ip => '127.0.0.1',
    }

    # Mysql
    class {
        'mysql::server':
            root_password => $mysql_values['root_password'],
            databases => {
                "${mysql_values['database']}" => {
                    ensure => 'present',
                    charset => 'utf8'
                }
            },
            users => {
                "${mysql_values['user']}@${mysql_values['host']}" => {
                    ensure => 'present',
                    password_hash => mysql_password($mysql_values['password'])
                }
            },
            grants => {
                "${mysql_values['user']}@${mysql_values['host']}/${mysql_values['database']}.*" => {
                    options   => ['GRANT'],
                    privileges => ['ALL'],
                    table => "${mysql_values['database']}.*",
                    user => "${mysql_values['user']}@${mysql_values['host']}"
                }
            }
    }

    class {
        'mysql::bindings':
            php_enable => true
    }

}

# disable IP tables for development
class iptables {
    service {'iptables':
        ensure => stopped,
    }
}

class setup_theme {
    require system_packages

    exec {
        "npm-install":
            cwd => $wordpress_values['theme_directory'],
            command => "npm install",
            path => [
                "/usr/local/node/node-default/bin",
                "/usr/local/bin",
                "/bin",
                "/usr/bin"
            ]
    }

    exec {
        "bower-install":
            cwd => $wordpress_values['theme_directory'],
            command => "grunt bower-install",
            path => [
                "/usr/local/node/node-default/bin",
                "/usr/local/bin",
                "/bin",
                "/usr/bin"
            ],
            require => Exec['npm-install']
    }

    exec {
        "grunt-setup":
            cwd => $wordpress_values['theme_directory'],
            command => "grunt setup",
            path => [
                "/usr/local/node/node-default/bin",
                "/usr/local/bin",
                "/bin",
                "/usr/bin"
            ],
            require => Exec['npm-install']
    }

}

class wordpress_config {
    require lamp

    file {
        "/vagrant/www/.env":
            ensure => "directory"
    }

    file {
        '/vagrant/www/.env/wp-config.php':
            source => $wordpress_values['config_file'],
            ensure => "file",
            replace => true,
            require => File["/vagrant/www/.env"]
    }

}

class restore_database {
    require lamp

    exec {
        "PopulateDatabase":
            command => "gunzip < ${wordpress_values['database_dumpfile']} | mysql -u ${mysql_values['user']}  --password='${mysql_values['password']}' ${mysql_values['database']}",
            logoutput => on_failure,
            path => ["/bin", "/usr/bin"],
            cwd => "/vagrant"
    }

}

include yum
include rpmforge
include system_packages
include lamp
include iptables
#include postfix
#include wordpress_config
#include setup_theme
#include restore_database
