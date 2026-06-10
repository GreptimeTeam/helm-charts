echo "\n================== Fetching UUID for kube-system namespace =================="

if UUID=$(kubectl get namespace kube-system -o jsonpath='{.metadata.uid}{"\n"}' 2>/dev/null); then
    if [ -n "$UUID" ]; then
        echo "Successfully got UUID: $UUID"
    else
        echo "Error: UUID is empty"
        exit 1
    fi
else
    echo "Error: Failed to get namespace UUID"
    exit 1
fi
