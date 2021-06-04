charts:
	helm repo add chatterbox-elastic https://helm.elastic.co/
	helm repo add chatterbox-ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm dep build

install: charts
	helm install chatterbox .

uninstall:
	helm uninstall chatterbox

getaddr:
	@echo "Voilà. App would be soon available at:"
	@kubectl get service chatterbox-ingress-nginx-controller -ojson | jq -r '"https://"+.status.loadBalancer.ingress[].ip | gsub("\\.";"-")+".nip.io/api/swagger_doc"'
