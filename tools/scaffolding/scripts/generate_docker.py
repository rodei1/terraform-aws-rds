"""This scripts generates boiler plates for using docker compose files. Input: Template files, Output: Docker compose files."""
from string import Template
import shutil
import argparse

parser = argparse.ArgumentParser(
                    prog='Docker Compose Generator',
                    description='This scripts generates boiler plates for using docker compose files. Input: Template files, Output: Docker compose files.',
                    epilog='.')
parser.add_argument('--docker-compose-template', type=str, required=True, help='The template file for the docker compose.')
parser.add_argument('--docker-compose-output', type=str, required=True, help='The output path for the docker compose.')
parser.add_argument('--env-template', type=str, required=True, help='The template file for the env file.')
parser.add_argument('--env-output', type=str, required=True, help='The output path for the env file.')
parser.add_argument('--docker-script-template', type=str, required=True, help='The template file for the script that is used by the generated docker compose file.')
parser.add_argument('--docker-script-output', type=str, required=True, help='The output path for the script used that is by the generated docker compose file.')
args = parser.parse_args()

docker_template = args.docker_compose_template
output_docker = args.docker_compose_output
env_template = args.env_template
output_env = args.env_output
docker_script_template = args.docker_script_template
output_docker_script = args.docker_script_output

vars_sub = {
    'pgpassword': 'example',
    'pgdatabase': 'example',
    'pghost': 'example',
    'pgport': 'example',
    'pguser': 'example'
}

with open(env_template, 'r', encoding='UTF-8') as f:
    src = Template(f.read())
    result = src.substitute(vars_sub)

with open(output_env, "w", encoding='UTF-8') as f:
    f.write(result)

shutil.copy(docker_template, output_docker)

shutil.copy(docker_script_template, output_docker_script)
