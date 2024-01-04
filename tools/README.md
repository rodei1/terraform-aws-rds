Run docker file:

cd /dfds/aws-modules-rds/tools

```bash
docker build -t scaffold .
```

mkdir auto-generated

```bash
docker run -v <absolute-path>/aws-modules-rds/:/input -v <absolute-path>/aws-modules-rds/tools/auto-generated:/output scaffold:latest
```
