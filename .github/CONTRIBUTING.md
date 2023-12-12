Releasing new change:

New releases are handled by the pipeline. Versioning scheme in these releases follows [Semantic Versioning 2.0.0](https://semver.org/)
The automatic release and versioning can be controlled via labelling the Pull requests as stated in the instructions in the PR template. These instructions will show up when opening new PR.


Module structure:
- `modules/` Contains the raw components
- `main.tf` Configure the needed components to create RDS instances according to the required specifications
- `locals.tf` Contains the logic to configure the defaults and parameters
- `outputs.tf` Outputs
- `variables` the parameters that can be passed to the module (Communicated the "API")
- `data.tf` Contains logic to query data needed for configuring the resources in the module