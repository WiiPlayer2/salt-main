__virtualname__ = 'counter'

_name = 'counters'

def __virtual__():
    return __virtualname__

def init(id):
    if not exists(id):
        if _name not in __grains__:
            __grains__[_name] = {}
        __grains__[_name][id] = 0
        __salt__['grains.set']('{}:{}'.format(_name, id), 0)
    return 0

def get(id):
    if exists(id):
        return __grains__[_name][id]
    return 0

def exists(id):
    if _name not in __grains__:
        return False
    if id not in __grains__[_name]:
        return False
    return True

def set(id, val):
    if not exists(id):
        init(id)
    __grains__[_name][id] = val
    __salt['grains.set']('{}:{}'.format(_name, id), val)
    return val

#TODO
#def remove(id):
#    if exists(id):
#    return True

def inc(id):
    return set(id, get(id) + 1)

def dec(id):
    return set(id, get(id) - 1)
