#!/usr/bin/python
"""
V1.2

Modification in recurse:
Recursion to old folders is made independent if found .knime data or not


"""

import sys
import xml.etree.ElementTree as ET
from os import listdir
from os.path import isfile, join

folder = sys.argv[1]

TYPES = {
    'STRING' : 'String',
    'INTEGER' : 'int',
    'DOUBLE' : 'double'
}

def listWorkflows(folder):
    list = []
    recurse(folder, list)
    return list

def recurse(f, list):
    content = listdir(f)
    isWorkflow = ("workflow.knime" in content) and ("settings.xml" not in content)
    if not isWorkflow:
        for c in content:
            path = join(f,c)
            if not isfile(path):
                recurse(path, list)
    else:
        list.append(f)

def createVarFile(workflowknime, outfile):
    tree = ET.parse(workflowknime)
    root = tree.getroot()
    f = open(outfile, "w")
    for child in root:
        if child.attrib['key'] == 'workflow_variables':
            for var in child:
                name = None
                value = None
                typ = None
                for entry in var:
                    if entry.attrib['key'] == 'name':
                        name = entry.attrib['value']
                    elif entry.attrib['key'] == 'class':
                        typ = entry.attrib['value']
                    elif entry.attrib['key'] == 'value':
                        value = entry.attrib['value']
                f.write(name + ':' + TYPES[typ] + ':' + value + "\n")
            break
    f.close()

for workflowFolder in listWorkflows(folder):
    createVarFile(join(workflowFolder, "workflow.knime"), join(workflowFolder, "dockermeta.knime"))
