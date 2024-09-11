#!/usr/bin/python3
"""
package        DevSecOps
name           handover.py
version        v1.0.0
description    Script para validação do README.md onde verificará todos os itens solicitados na frente Handover, retornando para o Groovy somente os que apresentam problemas.
author         Felipe Olivotto <felipe.olivotto@br.experian.com>

"""

import re
import sys
import json

"""
workspace
Descrição: Receberá como argumento o path do workspace 
"""
workspace = sys.argv[1]


"""
handover
Descrição: Json com os pilares do handover e seus respectivos itens
"""
handover = {
    "Solution Briefing": {
        "elements": {
            "Stakeholders": 0,
            "Customer Data": 0,
            "SLA/SLO": 0,
            "Plataform": 0,
            "Access Media": 0,
            "Business Stream": 0,
            "Capacity": 0,
            "Environment": 0
        },
        "value": 3.125
    },
    "Monitoring": {
        "elements": {
            "Availability": 0,
            "Performance": 0,
            "Business View": 0,
            "Syntethic": 0,
            "Golden Signals": 0
        },
        "value": 5
    },
    "App Details": {
        "elements": {
            "Solution Design": 0,
            "System Users": 0,
            "Return Code and Actions": 0,
            "ITSM": 0
        },
        "value": 6.25
    },
    "Escalation Matrix": {
        "elements": {
            "Escalation Matrix": 0
        },
        "value": 25
    }
}

try:
    with open('{}/README.md'.format(workspace), 'rb') as f:
        readme = f.read()
        readme = readme.decode(errors='ignore')
except FileNotFoundError:
    print("Arquivo README.md não encontrado. Impossível validar o Handover.")
    sys.exit(1)

## Validação README.md
for key in handover.keys():
    for handover_element in handover[key]["elements"].keys():
        if re.search(handover_element, readme):
            handover[key]["elements"][handover_element] = handover[key]["value"]

print(json.dumps(handover))
