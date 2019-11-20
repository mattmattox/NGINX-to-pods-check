#!/bin/bash

kubectl get namespace -o custom-columns=NAMESPACE:.metadata.name --no-headers | while read namespace
do
	echo "################################################################"
	echo "Searching for ingresses in $namespace"
	kubectl get ingress -n "$namespace" -o custom-columns=ingress:.metadata.name --no-headers | while read ingress
	do
		echo "Checking ingress $ingress in namespace $namespace"
		kubectl get ingress $ingress -n $namespace -o yaml | grep 'serviceName: ' | awk '{print $2}' | sort | uniq | while read servicename
		do
			echo "Service: $servicename"
			PORT="$(kubectl get endpoints "$servicename" -n "$namespace" -o yaml | grep 'port:' | awk '{print $2}')"
			kubectl get endpoints "$servicename" -n "$namespace" -o yaml | grep '\- ip:' | awk '{print $3}' | while read podip
			do
				echo "PodIP: $podip"
				kubectl -n ingress-nginx get pods -l app=ingress-nginx -o custom-columns=POD:.metadata.name,NODE:.spec.nodeName,IP:.status.podIP --no-headers | while read ingresspod nodename podip
				do
					echo "Checking $ingresspod on node $nodename with IP $podip"
					kubectl -n ingress-nginx exec $ingresspod -- curl -o /dev/null --connect-timeout 5 -s -w 'Connect:%{time_connect}\nStart Transfer: %{time_starttransfer}\nTotal: %{time_total}\nResponse code: %{http_code}\n' http://${podip}:${PORT}; RC=$?
					if [ $RC -ne 0 ];
					then
						echo "FAIL: ${nodename} cannot connectto ${epnodename}"
					else
						echo OK
					fi
				done
			done
		done
	done
	echo "################################################################"
done
