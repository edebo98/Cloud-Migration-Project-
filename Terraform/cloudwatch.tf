resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
alarm_name = "ec2-high-cpu"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
statistic = "Average"
period = 120
evaluation_periods = 2
threshold = 70
comparison_operator = "GreaterThanThreshold"

dimensions = {
InstanceId = aws_instance.wordpress_server.id
}
}

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
alarm_name = "rds-low-storage"
metric_name = "FreeStorageSpace"
namespace = "AWS/RDS"
statistic = "Average"
period = 300
evaluation_periods = 1
threshold = 2000000000
comparison_operator = "LessThanThreshold"

dimensions = {
DBInstanceIdentifier = aws_db_instance.wordpress_db.id
}
}




