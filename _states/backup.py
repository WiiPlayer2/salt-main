import os

def _checkDirectory(path) -> bool:
    if os.path.exists(path) and not os.path.isdir(path):
        raise Exception("Path is not a directory.")
    if not os.path.exists(path):
        os.mkdir(path)
        return False
    if not os.listdir(path):
        return False
    return True

def managed(name, path):
    ret = {'name': name,
       'result': False,
       'changes': {},
       'comment': ''}

    try:
        containsFiles = _checkDirectory(path)
        if containsFiles:
            # _backup(name, path)
            __salt__['backup.backup'](name, path)
        else:
            # _restore(name, path)
            __salt__['backup.restore'](name, path)
        ret['result'] = True

    except Exception as e:
        ret['comment'] = str(e)
    
    return ret

