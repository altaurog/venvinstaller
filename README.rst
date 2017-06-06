venvinstaller
==============

This is a simple (probably naïve) bash script to install and configure
a user-local virtualenv with virtualenvwrapper without requiring root
privileges or modifying system python packages.

This bootstrapping method is described here_.

.. _here: https://stackoverflow.com/a/5177027/519015

Usage
-----

::

    bash venvinstaller.sh [path/to/venvs]

The optional parameter specifies a directory path which will become the
``WORKON_HOME`` for virtualenvwrapper, in which all virtualenvs are
created.  The default is ``~/.venv``.
