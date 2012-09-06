# Changelog

## 1.6

 - Fix missing method errors when parsing OS X 10.8 documentation
 - Fix deprecation warnings from `ruby-progressbar`

## 1.5

 - Searching for constants, functions, data types, callbacks, and result codes are now supported!
 - Added smart completion; `Class-method`, `Class+method`, and `Class.property` can now be tab-completed

## 1.4

 - Fixed parsing error on non-ASCII characters. Patch submitted by farcaller.
 - Set width to use `$COLUMNS` environment variable, where available
 - Added `--width` option, for manually setting the text width

## 1.3

 - Added `--configure` command, for finding and indexing
   any docsets in preset default locations
 - Search term is now an argument, so no need for `-s`
 - Added example script for enabling bash completion on
   class and method names
 - Accept multiple arguments for the `--load-docset` option

## 1.2

 - Fix docset loading regression introduced in 1.1

## 1.1

 - Use ERB/bri for output formatting

## 1.0

Initial release