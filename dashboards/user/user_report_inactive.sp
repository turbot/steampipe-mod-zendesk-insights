variable "user_inactive_days" {
  type        = number
  description = "Number of days since last login to be considered inactive."
  default     = 90
}

dashboard "user_inactive_report" {
  title = "Zendesk Inactive Users Report"
  documentation = file("./dashboards/user/docs/user_report_inactive.md")

  tags = merge(local.user_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.user_count
      width = 2
    }

    card {
      query = query.user_inactive_count
      width = 2
      args  = {
        user_inactive_days = var.user_inactive_days
      }
    }
  }

  container {
    table {
      title = "Inactive Users"
      query = query.user_inactive_table

      args  = {
        user_inactive_days = var.user_inactive_days
      }

      column "url" {
        display = "none"
      }

      column "org_url" {
        display = "none"
      }

      column "User" {
        href = "{{.'url'}}"
      }

      column "Organization" {
        href = "{{.'org_url'}}"
      }
    }
  }
}

query "user_inactive_count" {
  sql = <<-EOQ
    select
      'Inactive' as label,
      count(*) as value,
      case
        when count(*) > 0 then 'alert'
        else 'ok'
      end as type
    from
      zendesk_user
    where
      active
    and
      (now()::date - last_login_at::date) > $1;
  EOQ

  param "user_inactive_days" {}
}

query "user_inactive_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      u.name as "User",
      u.role as "Role",
      u.suspended as "Account Suspended",
      now()::date - u.created_at::date as "Age in days",
      now()::date - u.last_login_at::date as "Days since logged in",
      u.url,
      o.url as org_url
    from
      zendesk_user u
    left outer join
      zendesk_organization o
    on
      u.organization_id = o.id
    where
      u.active
    and
      (now()::date - u.last_login_at::date) > $1
    order by
      "Days since logged in" desc;
  EOQ

  param "user_inactive_days" {}
}