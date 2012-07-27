# THE COCOADEX

Documentation lookup for Cocoa APIs, in the spirit of RI

Cocoadex parses Cocoa documentation files and creates a keyword index. Queries can then be run against the index for fast documentation lookup.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/kattrali/cocoadex)


## Installation

    gem install cocoadex

## Update

    gem update cocoadex && cocoadex --configure

## Configuration

Load any DocSets in known locations:

    cocoadex --configure

## Usage

### View Options

    cocoadex --help


### Loading a Custom DocSet

    cocoadex --load-docset [path] --load-docset [path2] ...


### Look up Documentation

    cocoadex [query]

#### Class Reference

Valid search terms are Class, method, and property names. Search scope can also be focused using delimiters, such as `Class-method` to find instance methods, `Class+method` to find class methods, or `Class.method` to find any matching method or property in `Class`.

#### Functions, Constants, Data Types, Callbacks, Structs...

Valid search terms are function, constant, data type, callback and struct names, as well as constant groups (e.g. `cocoadex "Social Profile Keys"`).

## Enabling Tab Completion

Cocoadex generates a tags file of all indexed search terms during configuration.

### Bash

Enable tab completion for bash by linking/saving `tools/bash_completion.sh` and adding the following to your .bash_profile (or similar):

    complete -C /path/to/cocoadex_completion.sh -o default cocoadex

### Z Shell

Add the following to your `.zshrc` to enable tab completion for zsh:

```sh

_cocoadex() {
    local cocoa_prefix
    read -l cocoa_prefix
    reply=(`cdex_completion "$cocoa_prefix"`)
}

compctl -K _cocoadex cocoadex
```

## Example Output

### Property Lookup Example

```sh
$ cocoadex tableView

-------------------------------------------------------------- tableView
                                                 (UITableViewController)

@property(nonatomic, retain) UITableView *tableView
------------------------------------------------------------------------
Returns the table view managed by the controller object.

Available in iOS 2.0 and later.
```


### Method Lookup Example

```sh
$ cocoadex tableView:viewForFoo

-------------------------------------- tableView:viewForFooterInSection:
                                                   (UITableViewDelegate)

  - (UIView *)tableView:(UITableView *)tableView
      viewForFooterInSection:(NSInteger)section

Returns: A view object to be displayed in the footer of section .
------------------------------------------------------------------------
Asks the delegate for a view object to display in the footer of the
specified section of the table view.

Parameters:

  tableView
    The table-view object asking for the view object.
  section
    An index number identifying a section of tableView .

Available in iOS 2.0 and later.
```

### Class Lookup Example (Clipped for brevity)

```sh
$ cocoadex UILabel

--------------------------------------------------------- Class: UILabel
                                       (UIView > UIResponder > NSObject)

Describes a control for displaying static text.
------------------------------------------------------------------------

Overview:

   (...)

Instance Methods:
  drawTextInRect:, textRectForBounds:limitedToNumberOfLines:

Properties:
  adjustsFontSizeToFitWidth, baselineAdjustment, enabled, font,
  highlighted, highlightedTextColor, lineBreakMode, minimumFontSize,
  numberOfLines, shadowColor, shadowOffset, text, textAlignment,
  textColor, userInteractionEnabled

```