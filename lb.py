from argparse import ArgumentParser
import requests
import urllib3
import json

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def show_nodes(lb_api_url, app_service_name):
    lb_response = requests.get(
        url=f'{lb_api_url}/http/services/{app_service_name}',
        verify=False
    ).json()

    return lb_response


def show_hostnames():
    pass


def show_requests():
    pass


def main():

    script_arguments = ArgumentParser(description='LB')
    script_arguments.add_argument('--describe', required=True, type=str)
    script_args = script_arguments.parse_args()

    lb_api_url = 'https://traefik.localhost/api'
    app_service_name = 'azapp@docker'

    if 'nodes' in script_args.describe:
        print(show_nodes(lb_api_url, app_service_name))

    elif 'hostnames' in script_args.describe:
        print('Unclear requirement')

    elif 'requests' in script_args.describe:
        print('Uncompleted requirement')

    elif 'all' in script_args.describe:
        print(show_nodes(lb_api_url, app_service_name))
        print('Unclear requirement')
        print('Uncompleted requirement')

    else:
        print("You must choose nodes, hostnames or requests")


if __name__ == "__main__":
    main()
