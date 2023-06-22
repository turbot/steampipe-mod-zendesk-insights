dashboard "ticket_age_report" {
  title = "Zendesk Ticket Age Report"
  documentation = file("./dashboards/ticket/docs/ticket_report_age.md")

  tags = merge(local.ticket_common_tags, {
    type     = "Report"
    category = "Age"
  })

  container {
    card {
      query = query.ticket_unsolved_count
      width = 2
    }

    card {
      query = query.ticket_unsolved_24_hours_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_unsolved_30_days_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_unsolved_30_90_days_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_unsolved_90_365_days_count
      width = 2
      type  = "info"
    }

    card {
      query = query.ticket_unsolved_1_year_count
      width = 2
      type  = "info"
    }
  }

  container {
    table {
      title = "Unsolved Tickets"
      query = query.ticket_unsolved_table

      column "url" {
        display = "none"
      }

      column "org_url" {
        display = "none"
      }

      column "Ticket" {
        href = "{{.'url'}}"
      }

      column "Organization" {
        href = "{{.'org_url'}}"
      }
    }
  }
}

query "ticket_unsolved_24_hours_count" {
  sql = <<-EOQ
    select
      '< 24 hours' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed')
    and
      created_at > now() - '1 days' :: interval;
  EOQ
}

query "ticket_unsolved_30_days_count" {
  sql = <<-EOQ
    select
      '1-30 days' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed')
    and
      created_at between symmetric now() - '1 days' :: interval and now() - '30 days' :: interval;
  EOQ
}

query "ticket_unsolved_30_90_days_count" {
  sql = <<-EOQ
    select
      '30-90 days' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed')
    and
      created_at between symmetric now() - '30 days' :: interval and now() - '90 days' :: interval;
  EOQ
}

query "ticket_unsolved_90_365_days_count" {
  sql = <<-EOQ
    select
      '90-365 days' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed')
    and
      created_at between symmetric now() - '90 days' :: interval and now() - '365 days' :: interval;
  EOQ
}

query "ticket_unsolved_1_year_count" {
  sql = <<-EOQ
    select
      '> 1 year' as label,
      count(*) as value
    from
      zendesk_ticket
    where
      status not in ('solved', 'closed')
    and
      created_at <= now() - '1 year' :: interval;
  EOQ
}

query "ticket_unsolved_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      t.id || ' ' || t.subject as "Ticket",
      t.status as "Status",
      t.priority as "Priority",
      u.name as "Assignee",
      now()::date - t.created_at::date as "Age in days",
      now()::date - t.updated_at::date as "Days since last update",
      o.url as org_url,
      t.url
    from
      zendesk_ticket t
    left outer join
      zendesk_organization o
    on
      t.organization_id = o.id
    left outer join
      zendesk_user u
    on
      t.assignee_id = u.id
    where
      status not in ('solved', 'closed')
    order by
      "Age in days" desc;
  EOQ
}