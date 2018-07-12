import logging
import os
import re
import threading
import xml.etree.ElementTree as ET

__virtualname__ = 'xml'
_lock = threading.Lock()

log = logging.getLogger(__name__)

#_name_regex = r"^(:|[A-Z]|[a-z]|[\xC0-\xD6]|[\xD8-\xF6]|[\xF8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD])(:|[A-Z]|[a-z]|[\xC0-\xD6]|[\xD8-\xF6]|[\xF8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|-|.|[0-9]|\xB7|[\u0300-\u036F]|[\u203F-\u2040])*$"
_name_regex = r"^[A-z_]([0-9A-z\-_\.])*$"

def __virtual__():
    return __virtualname__

def _is_valid_name(name):
    return re.fullmatch(_name_regex, name) is not None

def _ensure_path(root, path):
    try:
        splits = path.split('/')

        def _recurse(node, names):
            log.debug('Recursive ensuring path ({}, {})', node, names)

            if len(names) == 0:
                return node
            if not _is_valid_name(names[0]):
                return None

            next_node = node.find(names[0])
            if next_node == None:
                next_node = ET.SubElement(node, names[0])
            return _recurse(next_node, names[1:])

        return _recurse(root, splits)
    except Exception:
        log.exception('Failed ensuring path')
        return None

def set(name, file, value, path = None):
    ret = {'name': name,
       'result': False,
       'changes': {},
       'comment': ''}
    
    log.debug('set({}, {}, {})', repr(name), repr(file), repr(value))

    if not (os.path.exists(file) and os.path.isfile(file)):
        ret['comment'] = '\'{}\' does not exist or isn\'t a file'.format(file)
        return ret
    
    _lock.acquire()

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
    except Exception:
        log.exception('Failed setting value')
    finally:
        _lock.release()
