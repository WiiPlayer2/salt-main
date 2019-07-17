import tarfile
import dropbox
import tempfile
import socket
from dropbox.files import WriteMode
from dropbox.exceptions import ApiError, AuthError

__virtualname__ = 'backup'

def __virtual__():
    return __virtualname__

def _getDbx():
    token = __salt__['pillar.get']('backup:access_token')
    dbx = dropbox.Dropbox(token)
    return dbx

def _getBackupName(name):
    return '/' + socket.gethostname() + '_' + name + '.tar.gz'

def _compress(path) -> str:
    name = tempfile.mktemp()
    with tarfile.open(name, 'w:gz') as tar:
        tar.add(path, '')
        tar.close()
    return name

def _extract(path, tar):
    with tarfile.open(tar, 'r:gz') as tar:
        tar.extractall(path)
        tar.close()

def _download(remotePath, path):
    dbx = _getDbx()
    dbx.files_download_to_file(path, remotePath)

def _upload(path, remotePath):
    dbx = _getDbx()
    with open(path, 'rb') as f:
        dbx.files_upload(f.read(), remotePath, mode=WriteMode('overwrite'))

def backup(name, path):
    tmpPath = _compress(path)
    _upload(tmpPath, _getBackupName(name))

def restore(name, path):
    tmpPath = tempfile.mktemp()
    _download(_getBackupName(name), tmpPath)
    _extract(path, tmpPath)
