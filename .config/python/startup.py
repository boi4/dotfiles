

# https://bugs.python.org/issue20886

# Make python a little bit better


def get_history_file():
    import os
    if 'PYTHONHISTFILE' in os.environ:
        history = os.path.expanduser(os.environ['PYTHONHISTFILE'])
    elif 'XDG_DATA_HOME' in os.environ:
        history = os.path.join(os.path.expanduser(os.environ['XDG_DATA_HOME']),
                                'python', 'python_history')
    else:
        history = os.path.join(os.path.expanduser('~'),
                                '.python_history')

    history = os.path.abspath(history)
    _dir, _ = os.path.split(history)
    os.makedirs(_dir, exist_ok=True)

    return history



def override_sys_interactivehook(history):
    def custom_interactivehook():
        """
        mostly copied from lib/python3.8/site.py
        """
        import atexit
        try:
            import readline
            import rlcompleter
        except ImportError:
            return

        readline_doc = getattr(readline, '__doc__', '')
        if readline_doc is not None and 'libedit' in readline_doc:
            readline.parse_and_bind('bind ^I rl_complete')
        else:
            readline.parse_and_bind('tab: complete')

        try:
            readline.read_init_file()
        except OSError:
            # An OSError here could have many causes, but the most likely one
            # is that there's no .inputrc file (or .editrc file in the case of
            # Mac OS X + libedit) in the expected location.  In that case, we
            # want to ignore the exception.
            pass

        #if readline.get_current_history_length() == 0:
        #    history = os.path.join(os.path.expanduser('~'), '.python_history')
        try:
            readline.read_history_file(history)
        except OSError:
            pass

        def write_history():
            try:
                readline.write_history_file(history)
            except (FileNotFoundError, PermissionError):
                # home directory does not exist or is not writable
                # https://bugs.python.org/issue19891
                pass

        atexit.register(write_history)

    import sys
    sys.__interactivehook__ = custom_interactivehook


override_sys_interactivehook(get_history_file())
