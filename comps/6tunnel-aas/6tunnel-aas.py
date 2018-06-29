#!/usr/bin/env python3

import argparse
import os
import subprocess
from enum import Enum

PID_PATH='/var/run/6tunnel-aas'

def hash_str(obj):
    return format(hash(obj) & 0xffffffff, 'X')

def hash_path(hash):
    return os.path.join(PID_PATH, '{}.pid'.format(hash))

def run(cmd):
    print(cmd)
    os.system(cmd)

class Status(Enum):
    start = 'start'
    stop = 'stop'
    restart = 'restart'
    reload = 'reload'

class SixTunnelAAS():
    class Error(Exception):
        def __init__(self, message):
            self.message = message

    def __init__(self):
        self._parser = argparse.ArgumentParser(description='6tunnel as a service')
        self._parser.add_argument('status', type=Status, choices=list(Status))
        self._parser.add_argument('-c', '--configfolder', default='/etc/6tunnel-aas/')
        self._args = self._parser.parse_args()
        self._read_all_maps()

    def main(self):
        s = self._args.status
        print("[MAIN] {}".format(s))

        if s == Status.start:
            self.start()
        elif s == Status.stop:
            self.stop()
        elif s == Status.restart:
            self.restart()
        elif s == Status.reload:
            self.reload()

    def _read_all_maps(self):
        self._map = {}
        for f in os.listdir(self._args.configfolder):
            map = self._read_map(os.path.join(self._args.configfolder, f))
            self._map.update(map)

    def _read_map(self, path):
        f = open(path)
        map = {}
        for line in f.readlines():
            if line.startswith('#') or line.isspace() or len(line) == 0:
                continue
            map[hash_str(line)] = line
        f.close()
        return map

    def start(self):
        print("[START]")
        for hash in self._map:
            self._start_mapping(hash, self._map[hash])
    
    def stop(self):
        print("[STOP]")
        for f in os.listdir(PID_PATH):
            self._stop_file(os.path.join(PID_PATH, f))
    
    def restart(self):
        print("[RESTART]")
        self.stop()
        self.start()
    
    def reload(self):
        print("[RELOAD]")
        for f in os.listdir(PID_PATH):
            hash = f.split('.')[0]
            if hash not in self._map:
                self._stop_mapping(hash)
        for hash in self._map:
            self._reload_mapping(hash, self._map[hash])

    def _start_mapping(self, hash, line):
        if os.path.isfile(hash_path(hash)):
            raise SixTunnelAAS.Error('{0} already exists'.format(hash_path(hash)))
        cmd = '6tunnel {0} -p {1}'.format(line.strip(), hash_path(hash))
        run(cmd)
    
    def _stop_mapping(self, hash):
        if not os.path.isfile(hash_path(hash)):
            raise SixTunnelAAS.Error('{0} does not exists'.format(hash_path(hash)))
        self._stop_file(hash_path(hash))

    def _stop_file(self, file):
        pid_f = open(file)
        pid = pid_f.readline()
        pid_f.close()
        run('kill {}'.format(pid))

    def _restart_mapping(self, hash, line):
        try:
            self._stop_mapping(hash)
        except Exception:
            pass
        self._start_mapping(hash, line)
    
    def _reload_mapping(self, hash, line):
        try:
            self._start_mapping(hash, line)
        except Exception:
            pass

if __name__ == '__main__':
    SixTunnelAAS().main()
