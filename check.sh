#!/bin/bash

kubectl get namespace -o custom-columns=NAMESPACE:.metadata.name --no-headers | while read namespace
do
	kubectl get ingress -n "$namespace" -o custom-columns=ingress:.metadata.name --no-headers | while read ingress
	do
		kubectl get ingress $ingress -n $namespace -o yaml | grep 'serviceName: ' | awk '{print $2}' | sort | uniq | while read servicename
		do
			PORT="$(kubectl get endpoints "$servicename" -n "$namespace" -o yaml | grep 'port:' | awk '{print $2}')"
			if [[ "$PORT" == 'port:' ]]
			then
				PORT="80"
			fi
			kubectl get endpoints "$servicename" -n "$namespace" -o yaml | grep '\- ip:' | awk '{print $3}' | while read endpointpodip
			do
				kubectl -n ingress-nginx get pods -l app=ingress-nginx -o custom-columns=POD:.metadata.name,NODE:.spec.nodeName,IP:.status.podIP --no-headers | while read ingresspod nodename podip
				do
					PODNAME="$(kubectl get pods -n $namespace -o custom-columns=POD:.metadata.name,IP:.status.podIP --no-headers | grep "$endpointpodip" | tr -d ' ')"
					tput setaf 7; echo -n "Checking $PODNAME PodIP $endpointpodip in endpoint $servicename for ingress $ingress from $ingresspod on node $nodename "
					kubectl -n ingress-nginx exec $ingresspod -- curl -o /dev/null --connect-timeout 5 -s http://${endpointpodip}:${PORT}; RC=$?
					if [ $RC -ne 0 ]
					then
						tput setaf 1; echo "NOK"
					else
						tput setaf 2; echo "OK"
					fi
				done
			done
		done
	done
done
tput sgr0

