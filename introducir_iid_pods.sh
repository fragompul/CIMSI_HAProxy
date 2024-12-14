#!/bin/bash

# Namespace donde se encuentran los pods
NAMESPACE="default"

# Obtener la lista de pods en el namespace
PODS=$(microk8s kubectl get pods -n $NAMESPACE -o 
    jsonpath="{.items[*].metadata.name}")
# Iterar sobre cada pod:
for POD in $PODS; do
    echo "Modificando el pod: $POD"

    # Comando para añadir el JavaScript al archivo HTML 
    # (supongamos que el HTML está en:
    #     /usr/share/nginx/html/index.html)
    microk8s kubectl exec -n $NAMESPACE $POD -- sh -c "
        HOSTNAME=\$(hostname) &&
        sed -i '1i <div style=\"background-color: #ffd700; 
        padding: 10px; text-align: center;\">Pod ID: 
        '\$HOSTNAME'</div>' 
        /usr/local/apache2/htdocs/index.html 
    "

    # Verificar si el archivo se modificó correctamente
    if microk8s kubectl exec -n $NAMESPACE $POD -- grep -q 
        "$Pod ID:" /usr/local/apache2/htdocs/index.html; then
        echo "JavaScript añadido exitosamente al pod $POD"
    else
        echo "Error al modificar el pod $POD"
    fi
done

echo "Script finalizado"
