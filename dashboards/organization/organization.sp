category "organization" {
  title = "Organization"
  icon  = "diversity_2"
}

locals {
  organization_common_tags = {
    service = "Zendesk/Organization"
  }
}

query "organization_count" {
  sql = <<-EOQ
    select
      count(*) as "Organizations"
    from
      zendesk_organization;
  EOQ
}