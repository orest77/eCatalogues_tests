#!/usr/bin/env python3
import os
import venv
from pathlib import Path
import sys
testSuit = sys.argv[1]
root_path = Path(__file__).parent.resolve()
venv_dir = root_path / '.venv'


def runner():
    if not venv_dir.exists():
        try:
            venv.create(venv_dir, with_pip=True)
        except SystemError:
            print("Virtualenv was NOT created")
        finally:
            print("Virtualenv was created")
        if venv_dir.exists():
            try:
                os.system("pip install -r requirements.txt")
            except SystemError:
                print("Requirements were NOT installed")
            finally:
                print("Requirements were installed")
    elif venv_dir.exists():
        try:
            os.system("python -m robot.run --outputdir logs_folder " + testSuit)
        except SystemError:
            print("Tests were not started")
        finally:
            print("Finish!")

if __name__ == "__main__":
    runner()