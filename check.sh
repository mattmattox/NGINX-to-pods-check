#!/bin/bash

kubectl get namespace -o custom-columns=NAMESPACE:.metadata.name --no-headers | while read namespace
do
	echo "################################################################"
	echo "Searching for ingresses in $namespace"
  kubectl -n ingress-nginx get pods -l app=ingress-nginx -o custom-columns=POD:.metadata.name,NODE:.spec.nodeName,IP:.status.podIP --no-headers | while read ingresspod nodename podip
do
  echo "################################################################"
  echo "Checking $ingresspod"
  echo "Node: $nodename"
  echo "IP address: $podip"
  echo "################################################################"
done
