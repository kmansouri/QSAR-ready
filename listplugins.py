#!/usr/bin/python

import sys
import xml.etree.ElementTree as ET

file=sys.argv[1]
version=len(sys.argv) > 2 and sys.argv[2] == '-v'

tree = ET.parse(file)
root = tree.getroot()

feature = None
version = None

for child in root:
        if child.attrib['key'] == 'node-feature-symbolic-name':
            feature = child.attrib['value']
            if not version:
                break
        elif child.attrib['key'] == 'node-feature-version':
            version = child.attrib['value']
        if feature != None and version != None:
            break

# org.knime.features.base.feature.group is bound to the org.knime.product.desktop
if feature != None and feature != "org.knime.features.base.feature.group" and feature != None:
    if version:
        print feature + '/' + version
    else:
        print feature
