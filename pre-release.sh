#!/bin/bash

## Copyright (C) 2010-2012 by Cristian Henzel <oss@rspwn.com>
##
## This file is part of ClipIt.
##
## ClipIt is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## ClipIt is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

CURRENTYEAR=$(date "+%Y")
CURRENTSTAMP=$(date "+%Y-%m-%d %H:%M%z")

# TODO: Update copyright and version

## Update po files with new strings
./autogen.sh && ./configure
cd po
intltool-update -r
cd ..
make update-po

## Update po header files information
for filename in po/*.po po/*.pot; do
	sed -i "s/SOME DESCRIPTIVE TITLE\./ClipIt translation file./" "$filename"
	sed -i "s/YEAR THE PACKAGE'S COPYRIGHT HOLDER/2010-${CURRENTYEAR} Cristian Henzel <oss@rspwn.com>/" "$filename"
	sed -i "s/as the PACKAGE package\./as the ClipIt package\./" "$filename"
	sed -i "s/FIRST AUTHOR <EMAIL@ADDRESS>, YEAR/Cristian Henzel <oss@rspwn.com>, 2010/" "$filename"
	sed -i "s/Project-Id-Version:.*$/Project-Id-Version: ClipIt\\\\n\"/" "$filename"
	sed -i "s/Report-Msgid-Bugs-To:.*$/Report-Msgid-Bugs-To: Cristian Henzel <oss@rspwn.com>\\\\n\"/" "$filename"
	sed -i "s/YEAR-MO-DA HO:MI+ZONE/${CURRENTSTAMP}/" "$filename"
	sed -i "s/FULL NAME <EMAIL@ADDRESS>/Cristian Henzel <oss@rspwn.com>/" "$filename"
	sed -i "s/LANGUAGE <LL@li.org>/Cristian Henzel <oss@rspwn.com>/" "$filename"
	sed -i "s/CHARSET/UTF-8/" "$filename"
done

## Push po/clipit.pot to transifex
tx push -s

## Pull translations from transifex
tx pull -af
