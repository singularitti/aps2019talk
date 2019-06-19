#!/usr/bin/env sh

# Originally from https://github.com/latex3/latex3,
# modified by [@singularitti](https://github.com/singularitti) according to this
# [answer](https://tex.stackexchange.com/a/398831/61591).

# This script is used for testing using Travis
# A minimal current TL is installed adding only the packages that are
# required

# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua >/dev/null; then
    # Obtain TeX Live
    wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar -xzf install-tl-unx.tar.gz
    (
        cd install-tl-20* || exit

        # Install a minimal system
        ./install-tl --profile=../texlive/texlive.profile

        cd ..
    )
fi

# Just including texlua so the cache check above works
# Needed for any use of texlua even if not testing LuaTeX
tlmgr install luatex

# Then you can add one package per line in the texlive_packages file
# We need to change the working directory before including a file
cd "$(dirname "${BASH_SOURCE[0]}")" || exit
tlmgr install "$(cat texlive_packages)"

tlmgr install texliveonfly
tlmgr install latexmk

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
