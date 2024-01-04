scripts_path="/scripts"
source_module_path="/input"

if [ ! -d "/output" ]; then
   echo "output folder does not exist"
   exit 1
fi

# TERRAFORM DOCS
output_json_file="/tmp/doc.json"

# TERRAFORM
source_json_doc=$output_json_file
generated_tf_module_data="/tmp/tf_module.json"
tf_module_template="/templates/main.tf.template"
tf_module_output="/output/terraform/module.tf"
tf_output_folders="/output/terraform"
mkdir -p $tf_output_folders

# DOCKER
docker_compose_template="/templates/compose.yml.template"
docker_compose_output="/output/docker/compose.yml"
docker_env_template="/templates/.env.template"
docker_env_output="/output/docker/.env"
docker_script_template="/templates/restore.sh.template"
docker_script_output="/output/docker/restore.sh"
docker_output_folders="/output/docker"

mkdir -p $docker_output_folders

if [ -z "$(ls -a $source_module_path)" ]; then
   echo "empty $source_module_path"
   exit 1
fi


# TODO: CHECK FOR output folder mount

# 1) Generate docs for all modules in a repo
terraform-docs json --show "all" $source_module_path --output-file $output_json_file

# # 2) Generate TF files
python3 $scripts_path/generate_tf_module.py --source-tf-doc $source_json_doc --temp-work-folder $generated_tf_module_data --tf-module-template $tf_module_template --tf-output-path $tf_module_output

# # 3) Format TF files
terraform fmt $tf_output_folders

# 3) Generate Docker files
python3 $scripts_path/generate_docker.py --docker-compose-template $docker_compose_template --docker-compose-output $docker_compose_output  --env-template $docker_env_template --env-output $docker_env_output --docker-script-template $docker_script_template --docker-script-output $docker_script_output
# 4) Generate pipeline files
# TODO: generate pipeline
