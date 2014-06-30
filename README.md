vagrant-centos-lamp
=================

Cent 6.5, AMD64, PHP, MySQL, NodeJS, NPM

Mimics UConn's production stack or a typical CentOS LAMP stack.

### Dependencies

* [Ruby 1.9.3+](http://ruby-lang.org/)
* [Ruby Gems](http://rubygems.org/)
* [Virtual Box](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)

### Useage

This repository is intended to be included as a submodule in other projects. Include the `Vagrantfile` in your project's root and clone this repository into your project using the following commands:

`$ git submodule add git@github.com:uconn/vagrant-centos-lamp.git vagrant`
`$ git submodule update --init --recursive`
