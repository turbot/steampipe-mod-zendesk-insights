variable "user_seat_inactive_days" {
  type        = number
  description = "Number of days since last login of agent/admin (paid seat) to be considered inactive."
  default     = 90
}


dashboard "user_seat_inactive_report" {
  title = "Zendesk Inactive Paid Seats Report"
  documentation = file("./dashboards/user/docs/user_report_inactive_paid_seat.md")

  tags = merge(local.user_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.user_seat_count
      width = 2
    }

    card {
      query = query.user_seat_inactive_count
      width = 2
      args  = {
        user_inactive_days = var.user_inactive_days
      }
    }
  }

  container {
    table {
      title = "Inactive Paid Seat Users (Agent/Admin)"
      query = query.user_seat_inactive_table

      args  = {
        user_seat_inactive_days = var.user_seat_inactive_days
      }

      column "url" {
        display = "none"
      }

      column "User" {
        href = "{{.'url'}}"
      }
    }
  }
}

query "user_seat_count" {
  sql = <<-EOQ
    select
      count(*) as "Paid Seat Users"
    from
      zendesk_user
    where
      role in ('admin', 'agent')
  EOQ
}

query "user_seat_inactive_count" {
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
      role in ('admin', 'agent')
    and
      (now()::date - last_login_at::date) > $1;
  EOQ

  param "user_inactive_days" {}
}

query "user_seat_inactive_table" {
  sql = <<-EOQ
    select
      u.name as "User",
      u.role as "Role",
      u.suspended as "Account Suspended",
      now()::date - u.created_at::date as "Age in days",
      now()::date - u.last_login_at::date as "Days since logged in",
      u.url
    from
      zendesk_user u
    left outer join
      zendesk_organization o
    on
      u.organization_id = o.id
    where
      u.role in ('admin', 'agent')
    and
      (now()::date - u.last_login_at::date) > $1
    order by
      "Days since logged in" desc;
  EOQ

  param "user_seat_inactive_days" {}
}