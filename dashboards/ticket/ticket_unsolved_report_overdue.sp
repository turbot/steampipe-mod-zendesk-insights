dashboard "ticket_overdue_report" {
  title = "Zendesk Overdue Unsolved Tickets Report"
  documentation = file("./dashboards/ticket/docs/ticket_unsolved_report_overdue.md")

  tags = merge(local.ticket_common_tags, {
    type = "Report"
  })

  container {
    card {
      query = query.ticket_unsolved_count
      width = 2
    }

    card {
      query = query.ticket_unsolved_overdue_count
      width = 2
    }
  }

  container {
    table {
      title = "Overdue Tickets"
      query = query.ticket_unsolved_overdue_table

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

query "ticket_unsolved_overdue_count" {
  sql = <<-EOQ
    select
      'Overdue' as label,
      count(*) as value,
      case
        when count(*) > 0 then 'alert'
        else 'ok'
      end as type
    from
      zendesk_ticket t
    where
      status not in ('solved', 'closed')
    and 
      (due_at is not null and due_at::date < now()::date);
  EOQ
}

query "ticket_unsolved_overdue_table" {
  sql = <<-EOQ
    select
      o.name as "Organization",
      t.id || ' ' || t.subject as "Ticket",
      t.status as "Status",
      t.priority as "Priority",
      u.name as "Assignee",
      now()::date - t.due_at::date as "Days overdue",
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
    and 
      (due_at is not null and due_at::date < now()::date)
    order by
      "Days overdue" desc;
  EOQ
}