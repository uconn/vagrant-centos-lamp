vagrant-centos-lamp
=================

Cent 6.5, AMD64, PHP, MySQL, NodeJS, NPM

Mimics UConn's production stack or a typical CentOS LAMP stack.

### Dependencies

* [Ruby 1.9.3+](http://ruby-lang.org/)
* [Ruby Gems](http://rubygems.org/)
* [Virtual Box](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)

### Usage

This repository is intended to be included as a submodule in other projects. Include the `Vagrantfile` in your project's root and clone this repository into your project using the following commands:

    $ git submodule add git@github.com:uconn/vagrant-centos-lamp.git vagrant
    $ git submodule update --init --recursive

__For a working example of this project being used, check out our other project [UConn Wordpress Boilerplate](https://github.com/uconn/uconn-wordpress-boilerplate).__

---

## License

> The MIT License (MIT)
>
> Copyright (c) 2014 University of Connecticut
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
