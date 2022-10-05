# things to consider for new AKS with kubenet

## must have

- use kubenet instead of azure CNI
- allocate pod cidr that is not used elsewhere - align with network, for now, choose an unused 10.something range
- allow choice of VM SKU for different node pools
- allow chocie of autoscaling for user node pools
- use different variables for kubernetes version and orchestrator version
- limit roleassignments for flux identity
- check sysdig installation
- check cpu requirements for core componetns, is 4vCPU still required for system pool?




## nice to have

- block '--admin' ( impact on needing kubelogin)
- allow gitops per cluster (create folder in repo for each cluster?)
- move to Workload Identity Federation instead of AAD Pod Identity ( how to integrate with keyvault )
-  
