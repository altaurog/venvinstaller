#!/bin/bash
set -o nounset
set -o errexit

myrealpath() {
    echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

DEFAULT=~/.venv
WORKON_HOME=$(myrealpath ${1:-$DEFAULT})
VENV_VENV=$WORKON_HOME/venv

get_latest_pypi_link() {
    PACKAGE=$1
    FORMAT=$2
    PYPI="https://pypi.python.org"
    URLPATH=$(
        curl -sS $PYPI/simple/$PACKAGE/ \
        | sed -nr "s;.*<a href=\"../../(packages/[^\"]+)\".*>${PACKAGE}-([^<]+)$FORMAT<.*;\2 \1;p" \
        | sort -V \
        | tail -n 1 \
        | cut -d " " -f2
    )
    echo $PYPI/$URLPATH
}

add_to_bashrc() {
    cat >> ~/.bashrc <<EOF

export VIRTUALENVWRAPPER_PYTHON=$VENV_VENV/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV=$VENV_VENV/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_CLONE=$VENV_VENV/bin/virtualenv-clone
export WORKON_HOME=$WORKON_HOME
source $VENV_VENV/bin/virtualenvwrapper.sh
EOF
}


if [[ -e "$VENV_VENV/bin/python" ]]
then
    echo looks like virtualenv is already installed
else
    echo installing virtualenv into a virtualenv
    mkdir -p "$WORKON_HOME"
    cd "$WORKON_HOME"
    curl -sS $(get_latest_pypi_link virtualenv .tar.gz) > virtualenv.tar.gz
    tar xf virtualenv.tar.gz
    pushd virtualenv-*
    python virtualenv.py "$VENV_VENV"
    popd
    "$VENV_VENV"/bin/pip install virtualenv.tar.gz
    "$VENV_VENV"/bin/pip install virtualenvwrapper
    rm -rf virtualenv*

    if grep -q VIRTUALENV ~/.bashrc
    then
        echo "virtualenv config already in .bashrc"
    else
        echo "adding virtualenv config to .bashrc"
        add_to_bashrc
    fi
fi
