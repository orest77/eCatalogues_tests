import os
from munch import Munch, munchify
from json import load, loads


def load_data_from(file_name):
    """We assume that 'external_params' is a a valid json if passed
    """

    if not os.path.exists(file_name):
        file_name = os.path.join(os.path.dirname(__file__), 'data', file_name)
    with open(file_name) as file_obj:
        if file_name.endswith('.json'):
            file_data = Munch.fromDict(load(file_obj))
        elif file_name.endswith('.yaml'):
            file_data = Munch.fromYAML(file_obj)

    return munchify(file_data)