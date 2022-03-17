data "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_subnet_ids" "subnet" {
  vpc_id = "vpc-dc1988b7"
  #vpc_id = data.aws_vpcs.vpc.ids
  tags = {
    access-team = "development"
  }
}
