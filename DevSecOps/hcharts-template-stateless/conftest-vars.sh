#!/bin/bash
#definição das variaveis do conftest
VarsPolicy=(
    #Autoscaling HPA - Autoscaling desabilitado
        "K8S-HPA-001 15"
    #Autoscaling HPA Maximo de replicas igual ou menor que o mínimo
        "K8S-HPA-010 5"
    #Imagem com tag latest
        "K8S-IMG-010 5"
    #ImagePullPolicy: Always
        "K8S-IMG-020 5"
    #Repositorio de Imagens Externo/Inseguro
        "K8S-IMG-030 5"
    #Liveness Nao Definido
        "K8S-AVA-010 15"
    #Liveness initialDelaySeconds Nao Definido
        #"K8S-AVA-011 0"
    #livenessProbe.timeoutSeconds Nao Definido
        #"K8S-AVA-012 0"
    #Readiness Nao Definido    
        "K8S-AVA-020 15"
    #readinessProbe.timeoutSeconds Inconsistente  
        #"K8S-AVA-021 0"
    #CPU Request Nao Definido   
        "K8S-CAP-010 15"
    #CPU Limit Nao Definido   
        "K8S-CAP-020 10"
    #Memory Request Nao Definido
        "K8S-CAP-030 15"
    #Memory Limits Nao Definido
        "K8S-CAP-040 10"
    #maxUnavailable Diferente de 0
        #"K8S-AVA-040 0"
                )