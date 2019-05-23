#!/bin/bash
set -eu

if [ -z "$CA_PASS" ] || [ -z "$TS_PASS" ] ; then
    echo
    echo Enter Root-CA Secrets
    unset CA_PASS TS_PASS
    read -p "- Root-CA Secret: " -s CA_PASS ; echo
    read -p "- Truststore Secret: " -s TS_PASS ; echo
fi

rm -rf output/*
./gen_root_ca.sh $CA_PASS $TS_PASS

if [ -z "$CRT_NODE_DNAME" ] || [ -z "$CRT_CLIENT_DNAME" ] ; then
    if [ -z "$CRT_C" ] || [ -z "$CRT_O" ] || [ -z "$CRT_OU" ] || [ -z "$CRT_ST" ] ; then
        echo
        echo Enter Node and Client Certificate Fields
        unset CRT_C CRT_O CRT_OU CRT_ST
        read -p "- Country Name (C): " CRT_C
        read -p "- Organisation (O): " CRT_O
        read -p "- Organisational Unit (OU): " CRT_OU
        read -p "- State or Province Name  (ST): " CRT_ST
    fi
fi

if [ -z "$CRT_NODE_DNAME" ] ; then
    ./gen_node_cert.sh $CA_PASS $CRT_C $CRT_O $CRT_OU $CRT_ST
else
    ./gen_node_cert.sh $CA_PASS
fi

if [ -z "$CRT_CLIENT_DNAME" ] ; then
    ./gen_client_node_cert.sh $CA_PASS $CRT_C $CRT_O $CRT_OU $CRT_ST
else
    ./gen_client_node_cert.sh $CA_PASS
fi

rm -f ./*tmp*
