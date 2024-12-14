#!/bin/bash

systemctl stop haproxy

for i in {1..3}; do
    echo "Despliegue de la página web $i"
    # Eliminar despliegue previo
    echo "Borrando despliegues anteriores..."
    microk8s.kubectl delete service web${i}-httpd
    microk8s.kubectl delete hpa web${i}
    microk8s.kubectl delete deployment web${i}
    if [ $? -ne 0 ]; then
        echo "Error al elimiar los despliegues."
        exit 1
    fi

    # Actualizar imagen de docker
    echo "Actualizando imagen..."
    docker build --tag=manolilop/web${i}-httpd:latest 
        ./PaginaWeb${i}
    docker push manolilop/web${i}-httpd:latest

    # Crear el despliegue
    echo "Creando despliegues..."
    microk8s.kubectl create deployment web${i} 
        --image=manolilop/web${i}-httpd:latest --port=80 
        --replicas=5
    if [ $? -ne 0 ]; then
        echo "Error al crear despliegues."
        exit 1
    fi

    # Exponer el despliegue
    echo "Exponiendo despliegue como un servicio NodePort..."
    microk8s.kubectl expose deployment web${i} --type=NodePort 
        --name=web${i}-httpd --cluster-ip=10.152.183.10${i}
    if [ $? -ne 0 ]; then
        echo "Error al exponer el despliegue."
        exit 1
    fi

    echo "Configurando Horizontal Pod Autoscaler..."
    microk8s.kubectl autoscale deployment web${i} 
        --cpu-percent=$1 --min=$2 --max=$3
    if [ $? -ne 0 ]; then 
        echo "Error al configurar el HPA."
        exit 1
    fi
done

./introducir_iid_pods.sh
systemctl enable k8s-pod-watcher.service
systemctl start k8s-pod-watcher.service
echo "Despliegue y servicio creados exitosamente"
