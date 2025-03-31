#!/usr/bin/env python3

import os
import shutil
import tempfile
import argparse
import subprocess

SRCDIR = "/usr/share/native-laps-schema/"
TMPDIR = tempfile.mkdtemp(dir="/tmp")
SAMFILE = "/var/lib/samba/private/sam.ldb"

def update_files(srcdir, tempdir, domain_name):
    """
    Copies files from srcdir to tempdir and replaces "dc=mydomain,dc=lan" with domain_name
    """
    files = ["extended-rights.ldif", "laps-v2-schema-extension.ldif", "computer.ldif"]
    for file in files:
        with open(os.path.join(srcdir, file), "r") as f:
            content = f.read()
        content = content.replace("dc=mydomain,dc=lan", domain_name)
        with open(os.path.join(tempdir, file), "w") as f:
            f.write(content)

def install(dest_dir, sam_file):
    """
    Installs files using ldbadd and ldbmodify commands
    """
    files = ["extended-rights.ldif", "laps-v2-schema-extension.ldif", "computer.ldif"]
    for file in files[:2]:
        dest_file = os.path.join(dest_dir, file)
        command = 'ldbadd -H ' + sam_file + ' --option="dsdb:schema update allowed"=true ' + dest_file
        subprocess.run(command, shell=True)
    dest_file = os.path.join(dest_dir, files[2])
    command = 'ldbmodify -H ' + sam_file + ' --option="dsdb:schema update allowed"=true ' + dest_file
    subprocess.run(command, shell=True)

def cleanup(tempdir):
    """
    Removes contents of tempdir
    """
    shutil.rmtree(tempdir)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--domain", help="Domain name")
    parser.add_argument("--samfile", default=SAMFILE, help="Location of samba's sam.ldb file")
    args = parser.parse_args()

    srcdir = SRCDIR
    tempdir = TMPDIR

    update_files(srcdir, tempdir, args.domain)
    install(tempdir, args.samfile)
    cleanup(tempdir)

if __name__ == "__main__":
    main()