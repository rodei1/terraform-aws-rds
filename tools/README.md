Run docker file:

cd /dfds/terraform-aws-rds/tools

```bash
docker build -t scaffold .
```

mkdir auto-generated

```bash
docker run -v <absolute-path>/terraform-aws-rds/:/input -v <absolute-path>/terraform-aws-rds/tools/auto-generated/:/output scaffold:latest
```
