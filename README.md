# Bash Scripts Repository

Welcome to the Bash Scripts Repository! This repository contains various Bash scripts that are examples from the book *Cybersecurity Ops with Bash* by Paul Troncone and Carl Albing, PhD, published by O'Reilly. You can find more information about the book [here](https://www.oreilly.com/library/view/cybersecurity-ops-with/9781492041306/).

#### [vtjson.sh](/scripts/vtjson.sh)
This script reads a JSON file containing virus scan results, formats it for easier processing, and extracts and prints information about detected viruses. The regular expression is used to identify and capture relevant parts of each line, and the script only prints details for viruses that were detected (FOUND contains true). The json file used is from [VirusTotal](https://www.virustotal.com)
