SPI web site
============

This is the source code for [SPI's web site](https://spi-inc.org/).
The site uses [Ikiwiki](http://ikiwiki.info/) with input files using
Markdown.


Building
--------

The web site can be built using Ikiwiki with `bin/build-site`.  You have
to pass the source and destination directories.  For example, to build
the site from scratch, you can do:

    git clone git://git.spi-inc.org/website.git
    cd website
    mkdir html
    bin/build-site . html

The annual reports under `corporate/annual-reports` are built with
`pdflatex`.  The generated PDFs are checked into Git, so there's usually
no need to build them.  They only have to be rebuilt if there are
changes to the LaTeX source code.  Since the `Makefile` relies on
modification timestamps, you have to run a script first which updates
the timestamps based on the last Git commits:

    bin/restore-timestamp-git-commit corporate/annual-reports
    cd corporate/annual-reports
    # edit .tex
    make

Please don't commit modified PDFs if there was no change in the LaTeX
source (for example because you forgot to run
`bin/restore-timestamp-git-commit`).


Dependencies
------------

In order to build the web site, you need the following software:

    apt install ikiwiki libtext-multimarkdown-perl libimage-magick-perl

If you want to generate the annual reports, you need:

    apt install git texlive-latex-base texlive-latex-extra


Contributions
-------------

Please see the [information on making contributions](CONTRIBUTING.md).


License
-------

The SPI web site uses the [Attribution-ShareAlike 3.0 Unported (CC BY-SA
3.0)](https://creativecommons.org/licenses/by-sa/3.0/) license.  See
[LICENSE](LICENSE) for the complete license.

The Cantarell font uses the [SIL Open Font License](cantarell.LICENSE).

