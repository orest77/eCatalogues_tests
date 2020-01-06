#!/usr/bin/python
import os
import json
from json import loads
import asyncio
import requests
from munch import munchify
from requests.auth import HTTPBasicAuth

from client.exceptions import InvalidResponse


class ClientCriteria(object):
    def __init__(self, username='', password='', api_host='http://localhost:8000',
                 api_version='0', loop=asyncio.get_event_loop()):
        self._username = username
        self._password = password
        self.api_host = api_host
        self.api_version = api_version
        self.loop = loop
        self.url = api_host + '/api/' + api_version + '/'
        self.headers = {'Content-Type': 'application/json'}

    #######Method GET####################

    def get_criteria(self, path='', criteria_id=None):
        if isinstance(criteria_id, type(None)):
            response = requests.get(
                url=self.url + path + '/',
                auth=HTTPBasicAuth(self._username, self._password),
                headers=self.headers
            )
        else:
            response = requests.get(
                url=self.url + path + '/' + criteria_id + '/',
                auth=HTTPBasicAuth(self._username, self._password),
                headers=self.headers,
            )
        if response.status_code == 200:
            return munchify(loads(response.text))
        raise InvalidResponse(response)

    def get_status(self, path='', status_path=None):
        response = requests.get(
            url=self.url + path + '/' + status_path,
            auth=HTTPBasicAuth(self._username, self._password),
            headers=self.headers,
        )
        if response.status_code == 200:
            return munchify(loads(response.text))
        raise InvalidResponse(response)

    ######Method POST########################

    def create_criteria(self, path='', data={}):
        response = requests.post(
            url=self.url + path + '/',
            auth=HTTPBasicAuth(self._username, self._password),
            data=json.dumps(data),
            headers=self.headers
        )
        if response.status_code == 201:
            return munchify(loads(response.text))
        raise InvalidResponse(response)

    ##############Method PATCH#############

    def update_criteria(self, criteria_id, path='', data={}):
        response = requests.patch(
            url=self.url + path + '/' + criteria_id + '/',
            auth=HTTPBasicAuth(self._username, self._password),
            headers=self.headers,
            data=json.dumps(data)
        )
        if response.status_code == 200:
            return munchify(loads(response.text))
        raise InvalidResponse(response)

    ##########Method DELETE###################

    def delete_criteria(self, criteria_id, path=''):
        response = requests.delete(
            url=self.url + path + '/' + criteria_id + '/',
            auth=HTTPBasicAuth(self._username, self._password),
            headers=self.headers
        )
        if response.status_code == 200:
            return response.status_code
        raise InvalidResponse(response)
