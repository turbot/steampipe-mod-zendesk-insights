category "user" {
  title = "User"
  icon  = "person"
}

locals {
  user_common_tags = {
    service = "Zendesk/User"
  }
}

query "user_count" {
  sql = <<-EOQ
    select
      count(*) as "Users"
    from
      zendesk_user;
  EOQ
}