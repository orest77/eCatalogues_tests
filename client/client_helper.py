from http.client import BadStatusLine
from client.criteria_client import ClientCriteria
from retrying import retry


def retry_if_request_failed(exception):
    status_code = getattr(exception, 'status_code', None)
    print(status_code)
    if 500 <= status_code < 600 or status_code in (409, 429, 412):
        return True
    else:
        return isinstance(exception, BadStatusLine)


class StableClient(ClientCriteria):
    @retry(stop_max_attempt_number=100, wait_random_min=500,
           wait_random_max=4000, retry_on_exception=retry_if_request_failed)
    def request(self, *args, **kwargs):
        return super(StableClient, self).request(*args, **kwargs)



def prepare_api_wrapper(username, password, api_host, api_version):
    return StableClient(username, password, api_host, api_version)