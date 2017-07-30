# CronTab Interpreter in Ruby

## Install

Run the following command to install dependencies:

```bash
gem install bundler
bundler install
```

## Usage

This is a CLI app written in Ruby. In order to run this app you must invoke `ruby`
followed by the main filename and your CronTab string, e.g.:

```bash
ruby crontab.rb "*/15 0 1,15 * 1-5 /usr/bin/find"
> minute        0 15 30 45
> hour          0
> day of month  1 15
> month         1 2 3 4 5 6 7 8 9 10 11 12
> day_week      1 2 3 4 5
> cmd           /usr/bin/find
```

## Tests

You can run the available tests with this command:

```bash
rspec
```
