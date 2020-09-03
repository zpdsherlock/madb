#!/usr/bin/env bash
if [[ ! -d ${HOME}/bin ]]; then
	mkdir "${HOME}"/bin
fi
cp madb.sh ${HOME}/bin/madb
chmod +x ${HOME}/bin/madb
