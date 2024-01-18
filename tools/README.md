# Scaffolding guide

Change directory to where you have <https://github.com/dfds/terraform-aws-rds> checked out.

```bash
cd /dfds/terraform-aws-rds/tools
```

## Build container image and create required directory

Build the container image:

```bash
docker build -t scaffold .
```

Create output folder:

```bash
mkdir auto-generated
```

## Run container

Run newly created image:

```bash
cd ../..
docker run -v $PWD/terraform-aws-rds/:/input -v $PWD/terraform-aws-rds/tools/auto-generated/:/output scaffold:latest
```
