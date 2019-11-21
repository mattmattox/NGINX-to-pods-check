# NGINX-to-pods-check
This script is designed to walk through all the ingresses in a cluster and test that it can curl the backend pods from the NGINX pods. This is mainly done to verify the overlay network is working along with checking the overall configurtion.

## Run script
```
export KUBECONFIG-~/.kube/config
git clone https://github.com/mattmattox/NGINX-to-pods-check.git
cd NGINX-to-pods-check
bash ./check.sh
```

## Example output

### Broken pod
```
Checking Pod webserver-bad-8v4mh PodIP 10.42.0.252 on Port 80 in endpoint ingress-bad for ingress test-bad from nginx-ingress-controller-b2s2d on node a1ubphylbp01 NOK
```

### Working pod
```
Checking Pod webserver-good-65644cffd4-gbpkj PodIP 10.42.0.251 on Port 80 in endpoint ingress-good for ingress test-good from nginx-ingress-controller-b2s2d on node a1ubphylbp01 OK
```

## Testing

The following commands will deploy two workloads and ingresses. One that is working with a webserver that is responding on port 80. And the other will have the webserver disabled so it will fail to connect.

```
export KUBECONFIG-~/.kube/config
git clone https://github.com/mattmattox/NGINX-to-pods-check.git
cd NGINX-to-pods-check
cd webserver
kubectl apply -f deployment-bad.yml
kubectl apply -f deployment-good.yml
```
