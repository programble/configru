# Change Log

## 3.6.0 (10 October 2013)

 * Added `Configru.config` to access global `Config` object
 * Modified inspect for `Config` to be different from `Hash`

## 3.5.0 (9 October 2013)

 * Treat `nil` as being the correct type

## 3.4.0 (8 October 2013)

 * Added `Configru::Config` class
 * Re-evaluate DSL block on reload

## 3.3.1 (29 September 2013)

 * Added license to Gemspec

## 3.3.0 (24 September 2013)

 * Added boolean options

## 3.2.0 (25 May 2013)

 * Validate values against arrays using `include?`

## 3.1.0 (28 October 2012)

 * Added required options

## 3.0.0 (22 September 2012)

 * Added option arrays
 * Accessing a key that is not declared in `Configru.load` now raises
   `NoMethodError`, rather than returning `nil`.

## 2.0.1 (14 September 2012)

 * Fix: Cascade options in loaded files

## 2.0.0 (19 June 2012)

 * Entirely new API

## 0.5.0 (27 February 2012)

 * Added `Configru.raw` method to access raw hashmap

## 0.4.1 (27 February 2012)

 * Fix: Only replace underscores with hyphens in keys if the key does not exist

## 0.4.0 (8 January 2012)

 * Added `cascade 'c', ['a', 'b']` form

## 0.3.0 (30 July 2011)

 * Added `Configru.loaded_files`
 * Added the `options` method to the `Configru.load` DSL

## 0.2.0 (19 July 2011)

 * Added loading defaults from file
