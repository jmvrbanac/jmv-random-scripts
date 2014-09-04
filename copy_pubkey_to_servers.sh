#!/bin/bash

pub_key=~/.ssh/id_rsa.pub

while read server
do
	echo "Copying to $server"
	ssh-copy-id -i $pub_key root@$server
done <servers.txt
