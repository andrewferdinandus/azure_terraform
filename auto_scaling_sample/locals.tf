locals {
  # 1. දැනට තියෙන වෙලාව YYYY-MM-DD format එකට ගන්නවා
  current_date = formatdate("YYYY-MM-DD", timestamp())

  # 2. හැම resource එකකටම පොදුවේ දාන්න ඕන tag එක ලෑස්ති කරගන්නවා
  common_tags = {
    modified_on = local.current_date
    environment = var.project_env
  }
}