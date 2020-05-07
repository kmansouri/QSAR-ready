#!/usr/bin/python

import sys
import xml.etree.ElementTree as ET
import os
from distutils.version import LooseVersion

# Find versions of the contained workflows
highest = None
# Get all workflow.knime files in the folder
folder = sys.argv[1]
for root, dirs, files in os.walk(folder):
    for name in files:
        if name == "workflow.knime":
            tree = ET.parse(os.path.join(root, name))
            root = tree.getroot()
            for child in root:
                if child.attrib['key'] == 'created_by':
                    version = LooseVersion(child.attrib['value'])
                    if highest is None or version > highest:
                        highest = version
                    break

highest = str(highest)
print highest[0:highest.rfind(".")]
