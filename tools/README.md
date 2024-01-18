Run docker file:

cd /dfds/terraform-aws-rds/tools

```bash
docker build -t scaffold .
```

Create output folder:

```bash
mkdir auto-generated
```

Run docker:

```bash
cd ../..
docker run -v $PWD/terraform-aws-rds/:/input -v $PWD/terraform-aws-rds/tools/auto-generated/:/output scaffold:latest
```
