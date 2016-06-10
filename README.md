# WordPress Installer on your desktop.

WordPress development environment with PHP built-in web server + WP-CLI.

## Requires

* OSX
* Homebrew
* php 5.4 or later
* MySQL

### Recommend

* [Composer](https://getcomposer.org/)
* [Mailcatcher](http://mailcatcher.me/)

## Usage

```
$ curl https://.../run.sh | bash -s <db-user> <db-pass> <db-name> <port>
```

or

```
$ ./run.sh <db-user> <db-pass> <db-name> <port>
```

### Defaults

* db-user: `root`
* db-pass: (empty)
* db-name: `wpdev`
* port: `8080`

## How to use

```
$ mkdir ~/Desktop/wordpress && cd $_
$ curl https://raw.githubusercontent.com/konweb/wp-instant-setup/master/run.sh | bash
```

Or

```
$ git clone https://github.com/konweb/wp-instant-setup && cd wp-instant-setup
$ ./run.sh root root
```

### For MAMP users

```
$ mkdir ~/Desktop/wordpress && cd $_
$ curl https://raw.githubusercontent.com/konweb/wp-instant-setup/master/run.sh | bash -s root root
```

Or

```
$ git clone https://github.com/konweb/wp-instant-setup && cd wp-instant-setup
$ ./run.sh root root
```

## Default Account

* User: `admin`
* Password: `admin`

## Advanced Tips

Add alias into your `~/.bash_profile` like following.

```
alias wpserve="curl https://raw.githubusercontent.com/konweb/wp-instant-setup/master/run.sh | bash -s <db-user> <db-pass>"
```

Then just run:

```
$ wpserve <db-name> <port>
```
