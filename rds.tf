# Cluster
resource "aws_rds_cluster" "db" {
  cluster_identifier = "${var.default_tags.username}-db-cluster"
  db_subnet_group_name = aws_db_subnet_group.db.name
  engine = "aurora-postgresql"
  engine_mode = "provisioned"
  engine_version = "15.3"
  serverlessv2_scaling_configuration {
    max_capacity = 1
    min_capacity = 0.5
  }
  availability_zones = aws_subnet.private[*].availability_zone # Changed
  database_name = "bvanekdb" # Changed
  vpc_security_group_ids = [module.db_sg.sg_id] # Changed
  master_username = var.db_credentials.username
  master_password = var.db_credentials.password
  skip_final_snapshot = true
  tags = {
    "Name" = "${var.default_tags.username}-cluster"
  }
}

# Cluster instances
resource "aws_rds_cluster_instance" "db" {
    count = 2
    identifier = "${var.default_tags.username}-${count.index+1}"
    cluster_identifier = aws_rds_cluster.db.id
    instance_class = "db.serverless"
    engine = aws_rds_cluster.db.engine
    engine_version = aws_rds_cluster.db.engine_version
    db_subnet_group_name = aws_db_subnet_group.db.name
}

output "db_endpoints" {
  value = {
    writer = aws_rds_cluster.db.endpoint
    reader = aws_rds_cluster.db.reader_endpoint
  }
}

# db subnet group
resource "aws_db_subnet_group" "db" {
  name_prefix = "bvanek-tf-db"
  subnet_ids  = aws_subnet.private.*.id
  tags = {
    "Name" = "${var.default_tags.username}-group"
  }
}

# Security
module "db_sg" {
  source        = "./modules/rds"
  sg_name       = "${var.default_tags.username}-db-sg"
  description   = "SG for terraform rds"
  vpc_id        = aws_vpc.main.id
  sg_db_ingress = var.sg_db_ingress # We defined this
  sg_db_egress  = var.sg_db_egress
  sg_source     = ["${aws_vpc.main.default_security_group_id}"]
}