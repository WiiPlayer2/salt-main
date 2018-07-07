import logging
import salt.utils.platform

log = logging.getLogger(__name__)

HAS_WMI = False
if salt.utils.platform.is_windows():
    # attempt to import the python wmi module
    # the Windows minion uses WMI for some of its grains
    try:
        import wmi  # pylint: disable=import-error
        import salt.utils.winapi
        import win32api
        import salt.utils.win_reg
        HAS_WMI = True
    except ImportError:
        log.exception(
            'Unable to import Python wmi module, some core grains '
            'will be missing'
)

def _get_windows_user_info():
    wmi_c = wmi.WMI()
    accs = wmi_c.Win32_UserAccount()
    users = {}
    user_ids = {}
    for acc in accs:
        user_ids[acc.Name] = acc.SID
        users[acc.SID] = acc.Name
    return { 'users': users, 'user_ids': user_ids }

def main():
    if salt.utils.platform.is_windows():
        return _get_windows_user_info()
    return { }
