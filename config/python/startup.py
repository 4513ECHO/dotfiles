import datetime
import inspect
import readline
import sys

q = exit


class Dev:
    @staticmethod
    def pp(obj) -> None:
        print(inspect.getsource(obj))


# from https://unix.stackexchange.com/questions/121377/how-can-i-disable-the-new-history-feature-in-python-3-4
def register_readline_completion() -> None:
    # rlcompleter must be loaded for Python-specific completion
    try:
        import readline
        import rlcompleter
    except ImportError:
        return
    # Enable tab-completion
    readline_doc = getattr(readline, "__doc__", "")
    if readline_doc is not None and "libedit" in readline_doc:
        readline.parse_and_bind("bind ^I rl_complete")
    else:
        readline.parse_and_bind("tab: complete")


sys.__interactivehook__ = register_readline_completion

print(datetime.datetime.now())
