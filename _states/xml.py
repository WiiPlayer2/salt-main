import os
import xml.etree.ElementTree as ET
import threading

__virtualname__ = 'xml'
lock = threading.Lock()

def __virtual__():
    return __virtualname__

def set(name, file, value):
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
        node.text = value
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
