import os
import xml.etree.ElementTree as ET
import threading

__virtualname__ = 'xml'
lock = threading.Lock()

def __virtual__():
    return __virtualname__

def _ensure_path(root, path):
    try:
        splits = path.split('/')

        def _recurse(node, names):
            if len(names) == 0:
                return node
            next_node = node.find(names[0])
            if next_node == None:
                next_node = ET.SubElement(node, names[0])
            return _recurse(next_node, names[1:])
        
        return _recurse(root, splits)
    except:
        return None

def set(name, file, value, path = None):
    ret = {'name': name,
       'result': False,
       'changes': {},
       'comment': ''}
    
    if not (os.path.exists(file) and os.path.isfile(file)):
        ret['comment'] = '\'{}\' does not exist or isn\'t a file'.format(file)
        return ret
    
    lock.acquire()

    try:
        tree = ET.parse(file)

        node = None
        if path is not None:
            node = _ensure_path(tree.getroot(), path)
        else:
            node = _ensure_path(tree.getroot(), name)

        if node is None:
            node = tree.find(name)

        if node == None:
            ret['result'] = False
            ret['comment'] = 'Value \'{}\' of file \'{}\' was not found'.format(name, file)
            return ret

        if node.text == value:
            ret['result'] = True
            ret['comment'] = 'Value \'{}\' of file \'{}\' is already set to \'{}\''.format(name, file, value)
            return ret

        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = 'Value \'{}\' of file \'{}\' would be set to \'{}\''.format(name, file, value)
            return ret
        
        old_value = node.text
        node.text = str(value)
        tree.write(file)

        ret['result'] = True
        ret['comment'] = 'Value \'{}\' of file \'{}\' is set to \'{}\''.format(name, file, value)
        ret['changes'] = {
            name: {
                'old': old_value,
                'new': value
            }
        }
        return ret
    finally:
        lock.release()
